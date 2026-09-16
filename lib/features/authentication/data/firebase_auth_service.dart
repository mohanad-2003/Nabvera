import 'package:nabvera/core/notifications/push_notification_service.dart';
import 'package:nabvera/core/purchases/revenue_cat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_service.g.dart';

/// The Firebase Hosting URL a password-reset email's "Continue" link
/// points to after a successful reset on Firebase's hosted web page — a
/// real, already-authorized domain (Firebase Authentication > Authorized
/// domains), matching `AppRoutes.resetComplete` and the Android App Link
/// declared in `AndroidManifest.xml` / `firebase-hosting/.well-known/
/// assetlinks.json`.
const passwordResetContinueUrl =
    'https://fitness-app-fitbody-604e8.web.app/reset-complete';

/// Thin wrapper around [FirebaseAuth] (+ Google Sign-In) so the rest of the
/// app never touches the plugins directly — swapping providers later only
/// means editing this file.
class FirebaseAuthService {
  FirebaseAuthService(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(fullName);
    // `updateDisplayName` changes the profile, but the ID token the SDK
    // already has cached keeps carrying the *old* (empty, for a brand
    // new account) `name` claim until something forces a fresh one — a
    // plain `getIdToken()` right after this, with no forceRefresh, would
    // still hand back that stale token. That matters a lot here
    // specifically: the backend auto-provisions this user's Mongo profile
    // from that very first token's `name` claim (see
    // `backend/src/middlewares/authMiddleware.js`), and only ever does so
    // once — so a stale claim here doesn't just show the wrong name
    // briefly, it bakes "the part of the email before @" in as the
    // account's name permanently. Forcing a refresh now, before the
    // caller's first backend call, is what makes the *next* `getIdToken()`
    // (even a plain one) already carry the real name.
    await credential.user?.getIdToken(true);
    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      // The user closed the account picker — not a real auth failure.
      throw FirebaseAuthException(code: 'sign-in-cancelled');
    }
    final googleAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Sends Firebase's hosted password-reset email with a "continue URL"
  /// pointing at our own Firebase Hosting page. `handleCodeInApp` is
  /// deliberately left false: the reset itself still happens entirely on
  /// Firebase's hosted web page, not in-app — the continue URL only
  /// controls where its "Continue" link goes afterwards. No
  /// `androidPackageName`/`iOSBundleId`/`dynamicLinkDomain` are set, since
  /// those would make Firebase wrap the link in a Dynamic Link (deprecated
  /// — see `AppRoutes.resetComplete`'s doc comment); getting back into the
  /// app instead relies purely on the platform's own Android App Links /
  /// iOS Universal Links recognizing that continue URL.
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: passwordResetContinueUrl,
        handleCodeInApp: false,
      ),
    );
  }

  /// Whether the signed-in account has a password to change at all — false
  /// for a Google-only account, which [PasswordSettingsPage] uses to hide
  /// its own "wrong password"/"weak password" errors behind a clearer
  /// "this account signs in with Google" message instead.
  bool get canChangePassword =>
      _auth.currentUser?.providerData.any(
        (p) => p.providerId == 'password',
      ) ??
      false;

  /// Changes the signed-in user's password. Firebase requires a *recent*
  /// sign-in for this — re-authenticating with [currentPassword] first is
  /// what makes that requirement satisfied here rather than surfacing as a
  /// confusing `requires-recent-login` error straight from `updatePassword`.
  /// Throws [FirebaseAuthException]('wrong-password') if [currentPassword]
  /// doesn't match, and lets `updatePassword`'s own `weak-password` etc.
  /// propagate — both map to a message via `authErrorMessage`.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  /// The Firebase ID token to send as `Authorization: Bearer <token>` on
  /// backend requests. Null when signed out.
  Future<String?> getIdToken({bool forceRefresh = false}) {
    return _auth.currentUser?.getIdToken(forceRefresh) ?? Future.value(null);
  }
}

@Riverpod(keepAlive: true)
FirebaseAuthService firebaseAuthService(Ref ref) {
  return FirebaseAuthService(FirebaseAuth.instance, GoogleSignIn());
}

/// Live auth state — a page can `ref.watch` this to react to sign-in /
/// sign-out instead of polling `currentUser`.
@Riverpod(keepAlive: true)
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthServiceProvider).authStateChanges;
}

/// Signs the current user out, orchestrated from outside the provider
/// graph (a plain widget-triggered call, not a provider depending on
/// another provider) so this doesn't reintroduce the cycle that used to
/// exist when [FirebaseAuthService] itself read
/// `pushNotificationServiceProvider`: that provider is built from
/// `userRepositoryProvider` → `apiClientProvider` → `firebaseAuthServiceProvider`,
/// so `FirebaseAuthService` reading it back formed a circular dependency.
///
/// Unregistering must happen before the actual sign-out: it needs an
/// Authorization header, which requires `_auth.currentUser` to still exist
/// (see `ApiClient._headers`).
///
/// Takes a plain `read` function rather than a [Ref] so it works from both
/// a provider's `Ref` and a widget's `WidgetRef` (the two no longer share a
/// common base type as of Riverpod 3) — pass `ref.read` from either.
Future<void> signOutCurrentUser(
  T Function<T>(ProviderListenable<T> provider) read,
) async {
  await read(pushNotificationServiceProvider).unregisterCurrentDevice();
  await read(revenueCatServiceProvider).signOut();
  await read(firebaseAuthServiceProvider).signOut();
}
