import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth) : _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() => _firebaseAuth.currentUser;

  String getCurrentUserId() => _firebaseAuth.currentUser?.uid ?? '';

  bool isUserLoggedIn() => _firebaseAuth.currentUser != null;

  Future<String> getCurrentUsername() async {
    String uid = getCurrentUserId();
    if (uid.isEmpty) return '';

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return (userDoc.data() as Map<String, dynamic>)?['username'] ?? '';
    } catch (e) {
      print('Fehler beim Abrufen des Benutzernamens: $e');
      throw Exception('Fehler beim Abrufen des Benutzernamens');
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
    } catch (e) {
      print('Fehler bei der Registrierung: $e');
      throw Exception('Registrierung fehlgeschlagen');
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Fehler beim Anmelden: $e');
      throw Exception('Anmeldung fehlgeschlagen');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Fehler beim Abmelden: $e');
      throw Exception('Abmeldung fehlgeschlagen');
    }
  }

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> updateUsername(String newUsername) async {
    String uid = getCurrentUserId();
    if (uid.isEmpty) throw Exception('Kein Benutzer angemeldet');

    try {
      await _firestore.collection('users').doc(uid).update({
        'username': newUsername,
      });
    } catch (e) {
      print('Fehler beim Aktualisieren des Benutzernamens: $e');
      throw Exception('Aktualisierung des Benutzernamens fehlgeschlagen');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    if (userId.isEmpty) {
      print('Warnung: Versuch, ein Benutzerprofil mit leerer userId abzurufen');
      return {};
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return doc.exists ? (doc.data() as Map<String, dynamic>) : {};
    } catch (e) {
      print('Fehler beim Abrufen des Benutzerprofils: $e');
      throw Exception('Abrufen des Benutzerprofils fehlgeschlagen');
    }
  }

  // Neue Methode zum Aktualisieren des gesamten Benutzerprofils
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    String uid = getCurrentUserId();
    if (uid.isEmpty) throw Exception('Kein Benutzer angemeldet');

    try {
      await _firestore.collection('users').doc(uid).update(profileData);
    } catch (e) {
      print('Fehler beim Aktualisieren des Benutzerprofils: $e');
      throw Exception('Aktualisierung des Benutzerprofils fehlgeschlagen');
    }
  }
}
