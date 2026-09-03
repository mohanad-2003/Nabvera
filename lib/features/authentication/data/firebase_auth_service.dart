import 'package:fitness_app/core/notifications/push_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_service.g.dart';

/// Thin wrapper around [FirebaseAuth] (+ Google Sign-In) so the rest of the
/// app never touches the plugins directly — swapping providers later only
/// means editing this file.
class FirebaseAuthService {
  FirebaseAuthService(this._ref, this._auth, this._googleSignIn);

  final Ref _ref;
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

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    // Must happen before the actual sign-out: unregistering needs an
    // Authorization header, which requires `_auth.currentUser` to still
    // exist (see ApiClient._headers).
    await _ref.read(pushNotificationServiceProvider).unregisterCurrentDevice();
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
  return FirebaseAuthService(ref, FirebaseAuth.instance, GoogleSignIn());
}

/// Live auth state — a page can `ref.watch` this to react to sign-in /
/// sign-out instead of polling `currentUser`.
@Riverpod(keepAlive: true)
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthServiceProvider).authStateChanges;
}
