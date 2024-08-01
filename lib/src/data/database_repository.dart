import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';

abstract class DatabaseRepository {
  Future<List<FangData>> getUserFaenge(String userId);
  Future<void> addFang(FangData newFang);
  Future<List<FangData>> getFaenge();
  Future<List<String>> getFischArten();
  Future<List<String>> getAngelmethoden();
  Future<List<String>> getNaturkoeder();
  Future<void> saveUserProfile(String userID, Map<String, dynamic> profileData);
  Future<Map<String, dynamic>?> getUserProfile(String userId);
  Future<void> updateFang(String fangId, Map<String, dynamic> newData);
  Future<void> deleteFang(String fangId);
  Future<List<FangData>> getTopFaenge({int limit = 10});
  Future<List<FangData>> getFaengeByFischart(String fischart);
  Future<List<FangData>> getFaengeByGewaesser(String gewaesser);
  Future<int> countUserFaenge(String userId);
  Future<double> getAverageFangGroesse(String userId);
  Future<List<FangData>> getLatestFaenge(String userID, {int limit = 10});
}

class FirebaseDatabase implements DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<FangData>> getUserFaenge(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting user faenge: $e');
      return [];
    }
  }

  @override
  Future<void> addFang(FangData newFang) async {
    try {
      await _firestore.collection('faenge').add({
        ...newFang.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding fang: $e');
      rethrow;
    }
  }

  @override
  Future<List<FangData>> getFaenge() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting faenge: $e');
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
      print('Error getting fischarten: $e');
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
      print('Error getting angelmethoden: $e');
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
      print('Error getting naturkoeder: $e');
      return [];
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
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateFang(String fangId, Map<String, dynamic> newData) async {
    try {
      await _firestore.collection('faenge').doc(fangId).update(newData);
    } catch (e) {
      print('Error updating fang: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFang(String fangId) async {
    try {
      await _firestore.collection('faenge').doc(fangId).delete();
    } catch (e) {
      print('Error deleting fang: $e');
      rethrow;
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
      print('Error getting top faenge: $e');
      return [];
    }
  }

  @override
  Future<List<FangData>> getFaengeByFischart(String fischart) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('fischart', isEqualTo: fischart)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting faenge by fischart: $e');
      return [];
    }
  }

  @override
  Future<List<FangData>> getFaengeByGewaesser(String gewaesser) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('gewaesser', isEqualTo: gewaesser)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              FangData.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting faenge by gewaesser: $e');
      return [];
    }
  }

  @override
  Future<int> countUserFaenge(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting user faenge: $e');
      return 0;
    }
  }

  @override
  Future<List<FangData>> getLatestFaenge(String userID,
      {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userID)
          .orderBy('datum', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => FangData.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching latest faenge: $e');
      return [];
    }
  }

  @override
  Future<double> getAverageFangGroesse(String userID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userID)
          .get();

      if (querySnapshot.size == 0) return 0.0;

      double totalGroesse = 0;
      for (var doc in querySnapshot.docs) {
        totalGroesse += (doc.data() as Map<String, dynamic>)['groesse'] ?? 0;
      }
      return totalGroesse / querySnapshot.size;
    } catch (e) {
      print('Error getting average fang groesse: $e');
      return 0.0;
    }
  }
}
