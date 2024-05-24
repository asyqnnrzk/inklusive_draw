import 'package:InklusiveDraw/controller/register_controller.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../forget_password/forget_password_bottom_sheet.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({
    super.key,
  });

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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
              decoration: const InputDecoration(
                label: Text('Name'),
                hintText: 'Enter your name',
                prefixIcon: Icon(
                  Icons.person_pin_rounded,
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
              decoration: const InputDecoration(
                label: Text('Username'),
                hintText: 'Enter your username',
                prefixIcon: Icon(
                  Icons.person,
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
                hintText: 'Enter your password',
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  child: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              validator: (password) {
                if (password == null || password.isEmpty) {
                  return 'Please enter your password';
                }
                if (password.length < 8) {
                  return 'Password is too short';
                }
                RegExp regexPassword = RegExp(r'^[a-zA-Z0-9_]+$');
                if (!regexPassword.hasMatch(password)) {
                  return 'Please enter a valid password';
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.confirmPassword,
              obscureText: obscureConfirmPassword,
              decoration: InputDecoration(
                label: const Text('Confirm Password'),
                hintText: 'Re-enter your password',
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                  child: Icon(
                    obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              validator: (confirmPassword) {
                if (confirmPassword == null || confirmPassword.isEmpty)
                {
                  return 'Please re-enter your password';
                }
                // if (controller.confirmPasswordController.text !=
                //     controller.passwordController.text) {
                //   return 'Password is not match';
                // }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                label: Text('Email'),
                hintText: 'Enter your email',
                prefixIcon: Icon(
                  Icons.email,
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
                  return 'Please enter a valid email address';
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
                    RegisterController.instance.registerUser(
                      controller.email.text.trim(),
                      controller.password.text.trim()
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                      color: whiteColor
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}