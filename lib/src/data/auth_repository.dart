import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  // Attribute
  final FirebaseAuth _firebaseAuth;

  // Konstruktor
  AuthRepository(this._firebaseAuth);

  // Methoden

  /// returns the currently logged in [User]
  /// or `null` if no User is logged in
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// returns the UID of the currently logged in user
  /// or an empty string if no user is logged in
  String getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid ?? '';
  }

  Future<void> signUpWithEmailAndPassword(String email, String pw) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: pw);
  }

  Future<void> loginWithEmailAndPassword(String email, String pw) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: pw);
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
