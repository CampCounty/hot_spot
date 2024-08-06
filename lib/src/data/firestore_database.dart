import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:logger/logger.dart';

class FirestoreDatabase implements DatabaseRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger();

  FirestoreDatabase(this._firestore);

  @override
  Future<List<FangData>> getFaenge() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .orderBy('datum', descending: true)
          .get();

      List<FangData> faenge = querySnapshot.docs.map((doc) {
        return FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return faenge;
    } catch (e) {
      _logger.e('Error getting faenge: $e');
      return [];
    }
  }

  @override
  Future<List<String>> getFischArten() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('metadata').doc('fischarten').get();
      return List<String>.from(doc['arten'] as List);
    } catch (e) {
      _logger.e('Error getting fischarten: $e');
      return [];
    }
  }

  @override
  Future<void> addFang(FangData newFang) async {
    try {
      await _firestore.collection('faenge').add(newFang.toMap());
    } catch (e) {
      _logger.e('Error adding fang: $e');
      rethrow;
    }
  }

  @override
  Future<List<FangData>> getUserFaenge(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .orderBy('datum', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      _logger.e('Error getting user faenge: $e');
      return [];
    }
  }

  @override
  Future<List<String>> getAngelmethoden() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('metadata').doc('angelmethoden').get();
      return List<String>.from(doc['methoden'] as List);
    } catch (e) {
      _logger.e('Error getting angelmethoden: $e');
      return [];
    }
  }

  @override
  Future<List<String>> getNaturkoeder() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('metadata').doc('naturkoeder').get();
      return List<String>.from(doc['koeder'] as List);
    } catch (e) {
      _logger.e('Error getting naturkoeder: $e');
      return [];
    }
  }

  @override
  Future<int> countUserFaenge(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .get();
      return querySnapshot.size;
    } catch (e) {
      _logger.e('Error counting user faenge: $e');
      return 0;
    }
  }

  @override
  Future<void> deleteFang(String fangId) async {
    try {
      await _firestore.collection('faenge').doc(fangId).delete();
    } catch (e) {
      _logger.e('Error deleting fang: $e');
      rethrow;
    }
  }

  @override
  Future<double> getAverageFangGroesse(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .get();

      if (querySnapshot.size == 0) return 0.0;

      double totalGroesse = 0;
      for (var doc in querySnapshot.docs) {
        totalGroesse += (doc.data() as Map<String, dynamic>)['groesse'] ?? 0;
      }
      return totalGroesse / querySnapshot.size;
    } catch (e) {
      _logger.e('Error getting average fang groesse: $e');
      return 0.0;
    }
  }

  @override
  Future<List<FangData>> getFaengeByFischart(String fischart) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('fischart', isEqualTo: fischart)
          .orderBy('datum', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      _logger.e('Error getting faenge by fischart: $e');
      return [];
    }
  }

  @override
  Future<List<FangData>> getFaengeByGewaesser(String gewaesser) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('gewaesser', isEqualTo: gewaesser)
          .orderBy('datum', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      _logger.e('Error getting faenge by gewaesser: $e');
      return [];
    }
  }

  @override
  Future<List<FangData>> getTopFaenge({int limit = 10}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .orderBy('groesse', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      _logger.e('Error getting top faenge: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    if (userId.isEmpty) {
      _logger.w(
          'Warnung: Versuch, ein Benutzerprofil mit leerer userId abzurufen');
      return null;
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        _logger.w('Kein Benutzerprofil gefunden für userId: $userId');
        return null;
      }
    } catch (e) {
      _logger.e('Fehler beim Abrufen des Benutzerprofils: $e');
      return null;
    }
  }

  @override
  Future<void> saveUserProfile(
      String userID, Map<String, dynamic> profileData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .set(profileData, SetOptions(merge: true));
    } catch (e) {
      _logger.e('Error saving user profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateFang(String fangId, Map<String, dynamic> newData) async {
    try {
      await _firestore.collection('faenge').doc(fangId).update(newData);
    } catch (e) {
      _logger.e('Error updating fang: $e');
      rethrow;
    }
  }

  @override
  Future<List<FangData>> getLatestFaenge(String userID,
      {int limit = 10}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userID)
          .orderBy('datum', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      _logger.e('Error getting latest faenge: $e');
      return [];
    }
  }

  @override
  Future<void> addComment(
      String fangId, String userId, String commentText, String username) async {
    try {
      _logger.i(
          'Versuche Kommentar hinzuzufügen: fangId=$fangId, userId=$userId, username=$username');
      await _firestore
          .collection('faenge')
          .doc(fangId)
          .collection('comments')
          .add({
        'userId': userId,
        'username': username,
        'commentText': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _logger.i('Kommentar erfolgreich hinzugefügt');
    } catch (e) {
      _logger.e('Fehler beim Hinzufügen des Kommentars: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getComments(String fangId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .doc(fangId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      _logger.e('Fehler beim Abrufen der Kommentare: $e');
      return [];
    }
  }

  @override
  Future<String> getUsername(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return (doc.data() as Map<String, dynamic>)['username'] ??
          'Unbekannter Benutzer';
    } catch (e) {
      _logger.e('Fehler beim Abrufen des Benutzernamens: $e');
      return 'Unbekannter Benutzer';
    }
  }

  @override
  Future<bool> isPersoenlicheBestleistung(
      String userId, String fischart, double groesse) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .where('fischart', isEqualTo: fischart)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true;
      }

      double maxGroesse = 0;
      for (var doc in querySnapshot.docs) {
        double currentGroesse =
            (doc.data() as Map<String, dynamic>)['groesse'] ?? 0;
        if (currentGroesse > maxGroesse) {
          maxGroesse = currentGroesse;
        }
      }

      return groesse > maxGroesse;
    } catch (e) {
      _logger.e('Error checking personal best: $e');
      return false;
    }
  }

  @override
  Future<void> updateAllFaengePBStatus() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('faenge').get();

      Map<String, double> userFischartMaxGroesse = {};

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String userId = data['userID'];
        String fischart = data['fischart'];
        double groesse = data['groesse'];

        String key = '$userId-$fischart';
        if (userFischartMaxGroesse.containsKey(key)) {
          if (groesse > userFischartMaxGroesse[key]!) {
            userFischartMaxGroesse[key] = groesse;
          }
        } else {
          userFischartMaxGroesse[key] = groesse;
        }
      }

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String userId = data['userID'];
        String fischart = data['fischart'];
        double groesse = data['groesse'];

        String key = '$userId-$fischart';
        bool isPB = groesse == userFischartMaxGroesse[key];

        await doc.reference.update({'isPB': isPB});
      }
    } catch (e) {
      _logger.e('Error updating all faenge PB status: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMarkers() {
    // TODO: implement getMarkers
    throw UnimplementedError();
  }

  @override
  Future<void> saveMarker(
      String gewaesserName, double latitude, double longitude) {
    // TODO: implement saveMarker
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfilePicture(String userId, String imageUrl) {
    // TODO: implement updateProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updatedData) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
