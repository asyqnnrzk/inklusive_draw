import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void loginUser(String email, String password) async {
    try {
      // Try to log in the user
      await AuthRepository.instance.loginUserWithEmailAndPassword
        (email, password);

      Get.to(const Homepage());

    } catch (e) {
      // If login fails, display an error message
      Get.snackbar(
        '',
        '',
        titleText: Text(
          "We couldn't find you",
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'Please register first or check your email and password!',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redButton,
        colorText: blackColor,
        margin: const EdgeInsets.all(16.0),

      );
    }
  }
}
