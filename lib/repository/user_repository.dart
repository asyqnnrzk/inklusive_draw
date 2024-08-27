import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';
import 'package:InklusiveDraw/model/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../source/text_theme.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Store user in Firestore with UID as document ID
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Success!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'Your account has been created, please login!',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: greenButton,
        colorText: blackColor,
      );
    } catch (error) {
      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Uh oh!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'Something went wrong, please try again!',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redButton,
        colorText: blackColor,
      );
      print(error.toString());
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
