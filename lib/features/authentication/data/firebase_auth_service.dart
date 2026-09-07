import 'package:nabvera/core/notifications/push_notification_service.dart';
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
  await read(firebaseAuthServiceProvider).signOut();
}
