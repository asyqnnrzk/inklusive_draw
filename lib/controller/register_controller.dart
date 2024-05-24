import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  final name = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final email = TextEditingController();

  void registerUser(String email, String password) {
    AuthRepository.instance.registerUserWithEmailAndPassword(email, password);
  }
}