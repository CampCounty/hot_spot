import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:logger/logger.dart'; // Importieren Sie ein Logging-Framework

class FirestoreDatabase implements DatabaseRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger(); // Initialisieren Sie den Logger

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
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      _logger.e('Error getting user profile: $e');
      return null;
    }
  }

  @override
  Future<void> saveUserProfile(
      String userId, Map<String, dynamic> profileData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
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
}
