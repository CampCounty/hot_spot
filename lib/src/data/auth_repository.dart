import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  // Attribute
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Konstruktor
  AuthRepository(this._firebaseAuth) : _firestore = FirebaseFirestore.instance;

  // Methoden

  /// Gibt den aktuell angemeldeten [User] zurück
  /// oder `null`, wenn kein Benutzer angemeldet ist
  User? getCurrentUser() => _firebaseAuth.currentUser;

  /// Gibt die UID des aktuell angemeldeten Benutzers zurück
  /// oder einen leeren String, wenn kein Benutzer angemeldet ist
  String getCurrentUserId() {
    final user = _firebaseAuth.currentUser;
    return user?.uid ?? '';
  }

  /// Überprüft, ob ein Benutzer angemeldet ist
  bool isUserLoggedIn() => _firebaseAuth.currentUser != null;

  /// Gibt den Benutzernamen des aktuell angemeldeten Benutzers zurück
  /// oder einen leeren String, wenn kein Benutzer angemeldet ist oder der Benutzername nicht gefunden wurde
  Future<String> getCurrentUsername() async {
    String uid = getCurrentUserId();
    if (uid.isEmpty) return '';

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return (userDoc.data() as Map<String, dynamic>)['username'] ?? '';
      }
    } catch (e) {
      print('Fehler beim Abrufen des Benutzernamens: $e');
    }
    return '';
  }

  /// Registriert einen neuen Benutzer mit E-Mail, Passwort und Benutzername
  Future<void> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Speichern des Benutzernamens in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
    } catch (e) {
      print('Fehler bei der Registrierung: $e');
      rethrow;
    }
  }

  /// Meldet einen Benutzer mit E-Mail und Passwort an
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Fehler beim Anmelden: $e');
      rethrow;
    }
  }

  /// Meldet den aktuellen Benutzer ab
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Fehler beim Abmelden: $e');
      rethrow;
    }
  }

  /// Gibt einen Stream zurück, der Änderungen des Authentifizierungsstatus überwacht
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  /// Aktualisiert den Benutzernamen des aktuell angemeldeten Benutzers
  Future<void> updateUsername(String newUsername) async {
    String uid = getCurrentUserId();
    if (uid.isEmpty) throw Exception('Kein Benutzer angemeldet');

    try {
      await _firestore.collection('users').doc(uid).update({
        'username': newUsername,
      });
    } catch (e) {
      print('Fehler beim Aktualisieren des Benutzernamens: $e');
      rethrow;
    }
  }

  /// Gibt das Benutzerprofil zurück
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    if (userId.isEmpty) {
      print('Warnung: Versuch, ein Benutzerprofil mit leerer userId abzurufen');
      return null;
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print('Kein Benutzerprofil gefunden für userId: $userId');
        return null;
      }
    } catch (e) {
      print('Fehler beim Abrufen des Benutzerprofils: $e');
      return null;
    }
  }
}
