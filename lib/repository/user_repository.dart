import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:InklusiveDraw/model/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // store user in Firestore
  createUser(UserModel user) async {
    await _db.collection('users').add(user.toJson()).whenComplete(() =>
        Get.snackbar('Success', 'Your account has been created',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(88, 185, 161, 0.5),
        colorText: Colors.black54),
      )
        .catchError((error, stackTrace) {
          Get.snackbar('Error', 'Something wen wrong, try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromRGBO(88, 185, 161, 0.5),
          colorText: const Color(0xFFEC8696));
          print(error.toString());
    });
  }

  // fetch user's details
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection('users').where('email', isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // fetch all users
  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection('users').get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
}