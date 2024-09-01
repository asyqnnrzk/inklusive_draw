import 'package:InklusiveDraw/controller/register_controller.dart';
import 'package:InklusiveDraw/model/user/user_model.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/tts_service.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({
    super.key,
  });

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final TtsService _ttsService = TtsService();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? _passwordErrorMessage;
  String? _passwordConfirmErrorMessage;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(RegisterController());
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.name,
              decoration: InputDecoration(
                label: const Text('Name'),
                labelStyle: LightTextTheme.tfName,
                hintText: 'Enter your name',
                hintStyle: LightTextTheme.tfName,
                errorStyle: LightTextTheme.tfError,
                prefixIcon: const Icon(
                  Icons.person_pin_rounded,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _ttsService.speak('Please enter your name');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),
              validator: (name) {
                if (name == null || name.isEmpty) {
                  return 'Please enter your name';
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.username,
              decoration: InputDecoration(
                label: const Text('Username'),
                labelStyle: LightTextTheme.tfName,
                hintText: 'Enter your username',
                hintStyle: LightTextTheme.tfName,
                errorStyle: LightTextTheme.tfError,
                prefixIcon: const Icon(
                  Icons.person,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _ttsService.speak('Please enter your username');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),
              validator: (username) {
                if (username == null || username.isEmpty) {
                  return 'Please enter your username';
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.password,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                label: const Text('Password'),
                labelStyle: LightTextTheme.tfName,
                hintText: 'Enter your password',
                hintStyle: LightTextTheme.tfName,
                errorStyle: LightTextTheme.tfError,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      child: Icon(
                        obscurePassword ? Icons.visibility : Icons
                            .visibility_off,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_passwordErrorMessage != null) {
                          _ttsService.speak(_passwordErrorMessage!);
                        } else {
                          _ttsService.speak('Please enter your password');
                        }
                      },
                      icon: const Icon(
                        Icons.volume_up,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              validator: (password) {
                if (password == null || password.isEmpty) {
                  _passwordErrorMessage = 'Please enter your password';
                  return _passwordErrorMessage;
                }
                if (password.length < 8) {
                  _passwordErrorMessage = 'Password is too short';
                  return _passwordErrorMessage;
                }
                RegExp regexPassword = RegExp(r'^[a-zA-Z0-9_]+$');
                if (!regexPassword.hasMatch(password)) {
                  _passwordErrorMessage = 'Only a-z, 0-9, _ accepted';
                  return _passwordErrorMessage;
                }
                _passwordErrorMessage = null;
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.confirmPassword,
              obscureText: obscureConfirmPassword,
              decoration: InputDecoration(
                label: const Text('Confirm Password'),
                labelStyle: LightTextTheme.tfName,
                hintText: 'Re-enter your password',
                hintStyle: LightTextTheme.tfName,
                errorStyle: LightTextTheme.tfError,
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        obscureConfirmPassword ? Icons.visibility : Icons
                            .visibility_off,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_passwordConfirmErrorMessage != null) {
                          _ttsService.speak(_passwordConfirmErrorMessage!);
                        } else {
                          _ttsService.speak('Please re-enter your password');
                        }
                      },
                      icon: const Icon(
                        Icons.volume_up,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              validator: (confirmPassword) {
                if (confirmPassword == null || confirmPassword.isEmpty)
                {
                  _passwordConfirmErrorMessage = 'Please re-enter your '
                      'password';
                  return _passwordConfirmErrorMessage;
                }
                if (confirmPassword != controller.password.text) {
                  _passwordConfirmErrorMessage = 'Password do not match';
                  return _passwordConfirmErrorMessage;
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                label: const Text('Email'),
                labelStyle: LightTextTheme.tfName,
                hintText: 'Enter your email',
                hintStyle: LightTextTheme.tfName,
                errorStyle: LightTextTheme.tfError,
                prefixIcon: const Icon(
                  Icons.email,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _ttsService.speak('Please enter your email');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return 'Please enter your email';
                }
                RegExp regexEmail = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  caseSensitive: false,
                );
                if (!regexEmail.hasMatch(email)) {
                  return 'Please enter a valid email';
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(formKey.currentState!.validate()) {

                    final user = UserModel(
                      name: controller.name.text.trim(),
                      username: controller.username.text.trim(),
                      password: controller.password.text.trim(),
                      email: controller.email.text.trim(),
                      signUpDate: Timestamp.fromDate(DateTime.now()),
                      lastLoggedIn: Timestamp.fromDate(DateTime.now()),
                      isDeleted: false,
                    );

                    RegisterController.instance.createUser(user);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor
                ),
                child: Text(
                  'Register',
                  style: LightTextTheme.loginBtn
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}