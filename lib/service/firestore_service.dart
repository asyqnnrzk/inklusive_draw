import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()!;
    } else {
      throw Exception('User not found');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final profileSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('profile')
        .get();

    if (profileSnapshot.docs.isNotEmpty) {
      return profileSnapshot.docs.first.data();
    } else {
      throw Exception('Profile not found for user');
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data)
  async {
    final profileCollection = _firestore.collection('users').doc(userId)
        .collection('profile');

    final profileSnapshot = await profileCollection.get();
    if (profileSnapshot.docs.isNotEmpty) {
      await profileCollection.doc(profileSnapshot.docs.first.id).update(data);
    } else {
      await profileCollection.add(data);
    }
  }
}
