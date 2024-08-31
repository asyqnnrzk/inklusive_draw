import 'package:InklusiveDraw/source/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:InklusiveDraw/model/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../source/text_theme.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Store user in Firestore with UID as document ID
  Future<void> createUser(UserModel user) async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String uid = userCredential.user!.uid;

      final userJson = await user.copyWith(id: uid).toJsonWithHashedPassword();

      await _db.collection('users').doc(uid).set(userJson);

      print('User created successfully with ID: $uid');

      await _createUserProfile(uid);

      print('Profile created successfully for user ID: $uid');

      // Success Snackbar
      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Success!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'Your account has been created!',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: greenButton,
        colorText: blackColor,
      );
    } catch (error) {

      String errorMessage = 'Something went wrong, please try again!';

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'This email address is already in use. '
                'Please login!';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid. Check the email!';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak. Create a strong one!';
            break;
          case 'operation-not-allowed':
            errorMessage = 'This operation is not allowed. '
                'Please contact support.';
            break;
          case 'user-disabled':
            errorMessage = 'This user has been disabled. '
                'Please contact support.';
            break;
          default:
            errorMessage = 'An unknown error occurred. '
                'Please try again later.';
        }
      }

      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Uh oh!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          errorMessage,
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redButton,
        colorText: blackColor,
      );
      print('Error during user creation: ${error.toString()}');
    }
  }

  Future<String> getImageUrl(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    final url = await ref.getDownloadURL();
    return url;
  }

  // Create a profile subcollection for the user
  Future<void> _createUserProfile(String userId) async {
    final userDefault = await getImageUrl('images/default_profile.png');
    try {
      await _db.collection('users').doc(userId).collection('profile')
          .doc(userId).set({
        'avatar': userDefault,
        'bio': 'Default bio',
        'following': 0,
        'posts': 0,
      });
    } catch (e) {
      print('Failed to create profile for user ID: $userId. Error: $e');
      rethrow;
    }
  }

  // Fetch user's details
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection('users').where
      ('email', isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // Fetch all users
  Future<List<UserModel>> allUsers() async {
    final snapshot = await _db.collection('users').get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e))
        .toList();
    return userData;
  }
}
