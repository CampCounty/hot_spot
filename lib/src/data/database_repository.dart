import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';

abstract class DatabaseRepository {
  Future<List<FangData>> getUserFaenge(String userId);
  Future<void> addFang(FangData newFang);
  Future<List<FangData>> getFaenge();
  Future<List<String>> getFischArten();
  Future<List<String>> getAngelmethoden();
  Future<List<String>> getNaturkoeder();
  Future<void> saveUserProfile(String userId, Map<String, dynamic> profileData);
  Future<Map<String, dynamic>?> getUserProfile(String userId);
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updatedData);
  Future<void> updateProfilePicture(String userId, String imageUrl);
  Future<void> updateFang(String fangId, Map<String, dynamic> newData);
  Future<void> deleteFang(String fangId);
  Future<List<FangData>> getTopFaenge({int limit = 10});
  Future<List<FangData>> getFaengeByFischart(String fischart);
  Future<List<FangData>> getFaengeByGewaesser(String gewaesser);
  Future<int> countUserFaenge(String userId);
  Future<double> getAverageFangGroesse(String userId);
  Future<List<FangData>> getLatestFaenge(String userID, {int limit = 10});
  Future<void> addComment(
      String fangId, String userId, String commentText, String username);
  Future<List<Map<String, dynamic>>> getComments(String fangId);
  Future<String> getUsername(String userId);
  Future<bool> isPersoenlicheBestleistung(
      String userId, String fischart, double groesse);
  Future<void> updateAllFaengePBStatus();
  Future<void> saveMarker(
      String gewaesserName, double latitude, double longitude);
  Future<List<Map<String, dynamic>>> getMarkers();
}

class FirebaseDatabase implements DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print('Error getting user faenge: $e');
      return [];
    }
  }

  @override
  Future<void> addFang(FangData newFang) async {
    try {
      bool isPB = await isPersoenlicheBestleistung(
        newFang.userID,
        newFang.fischart,
        newFang.groesse,
      );

      FangData fangWithPB = newFang.copyWith(isPB: isPB);

      DocumentReference docRef =
          await _firestore.collection('faenge').add(fangWithPB.toMap());

      if (isPB) {
        await updateOtherFangsPBStatus(
            newFang.userID, newFang.fischart, docRef.id);
      }
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
          .orderBy('datum', descending: true)
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
      String userId, Map<String, dynamic> profileData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
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
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfilePicture(String userId, String imageUrl) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error updating profile picture: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateFang(String fangId, Map<String, dynamic> newData) async {
    try {
      await _firestore.collection('faenge').doc(fangId).update(newData);

      DocumentSnapshot doc =
          await _firestore.collection('faenge').doc(fangId).get();
      FangData updatedFang =
          FangData.fromMap(doc.data() as Map<String, dynamic>, fangId);
      bool isPB = await isPersoenlicheBestleistung(
        updatedFang.userID,
        updatedFang.fischart,
        updatedFang.groesse,
      );
      if (isPB != updatedFang.isPB) {
        await _firestore
            .collection('faenge')
            .doc(fangId)
            .update({'isPB': isPB});
        if (isPB) {
          await updateOtherFangsPBStatus(
              updatedFang.userID, updatedFang.fischart, fangId);
        }
      }
    } catch (e) {
      print('Error updating fang: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFang(String fangId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('faenge').doc(fangId).get();
      FangData fang =
          FangData.fromMap(doc.data() as Map<String, dynamic>, fangId);

      await _firestore.collection('faenge').doc(fangId).delete();

      if (fang.isPB) {
        await updatePBAfterDelete(fang.userID, fang.fischart);
      }
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
          .orderBy('groesse', descending: true)
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
          .orderBy('datum', descending: true)
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
          .where('userID', isEqualTo: userId)
          .get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting user faenge: $e');
      return 0;
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
      print('Error getting average fang groesse: $e');
      return 0.0;
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
  Future<void> addComment(
      String fangId, String userId, String commentText, String username) async {
    try {
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
    } catch (e) {
      print('Error adding comment: $e');
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
      print('Error getting comments: $e');
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
      print('Error getting username: $e');
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
          .orderBy('groesse', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true; // Erster Fang dieser Art
      }

      double maxGroesse = (querySnapshot.docs.first.data()
              as Map<String, dynamic>)['groesse'] ??
          0.0;
      return groesse >= maxGroesse;
    } catch (e) {
      print('Error checking for persönliche Bestleistung: $e');
      return false;
    }
  }

  @override
  Future<void> updateAllFaengePBStatus() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        List<String> fischarten = await getFischArten();

        for (String fischart in fischarten) {
          QuerySnapshot fangSnapshot = await _firestore
              .collection('faenge')
              .where('userID', isEqualTo: userId)
              .where('fischart', isEqualTo: fischart)
              .orderBy('groesse', descending: true)
              .get();

          if (fangSnapshot.docs.isNotEmpty) {
            // Setze den größten Fang als PB
            await fangSnapshot.docs.first.reference.update({'isPB': true});

            // Setze alle anderen als nicht-PB
            for (var doc in fangSnapshot.docs.skip(1)) {
              await doc.reference.update({'isPB': false});
            }
          }
        }
      }
    } catch (e) {
      print('Error updating all Faenge PB status: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveMarker(
      String gewaesserName, double latitude, double longitude) async {
    try {
      await _firestore.collection('gewaesser').add({
        'name': gewaesserName,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      print('Error saving marker: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMarkers() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('gewaesser').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting markers: $e');
      return [];
    }
  }

  Future<void> updateOtherFangsPBStatus(
      String userId, String fischart, String newPBFangId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .where('fischart', isEqualTo: fischart)
          .where('isPB', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        if (doc.id != newPBFangId) {
          await doc.reference.update({'isPB': false});
        }
      }
    } catch (e) {
      print('Error updating other fangs PB status: $e');
      rethrow;
    }
  }

  Future<void> updatePBAfterDelete(String userId, String fischart) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .where('fischart', isEqualTo: fischart)
          .orderBy('groesse', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({'isPB': true});
      }
    } catch (e) {
      print('Error updating PB after delete: $e');
      rethrow;
    }
  }

  Future<int> getUserPBCount(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('faenge')
          .where('userID', isEqualTo: userId)
          .where('isPB', isEqualTo: true)
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error getting user PB count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getTopAnglers({int limit = 10}) async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> anglers = [];

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        int pbCount = await getUserPBCount(userId);
        String username = userDoc['username'] ?? 'Unbekannter Angler';

        anglers.add({
          'userId': userId,
          'username': username,
          'pbCount': pbCount,
        });
      }

      anglers.sort((a, b) => b['pbCount'].compareTo(a['pbCount']));
      return anglers.take(limit).toList();
    } catch (e) {
      print('Error getting top anglers: $e');
      return [];
    }
  }
}
