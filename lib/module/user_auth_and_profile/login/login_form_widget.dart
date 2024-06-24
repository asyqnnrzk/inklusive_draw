import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/login_controller.dart';
import '../forget_password/forget_password_bottom_sheet.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(LoginController());
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                label: Text('Email'),
                hintText: 'Enter your username',
                prefixIcon: Icon(
                  Icons.email,
                ),
              ),
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return 'Please enter your email';
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
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordBottomSheet(context);
                },
                child: Text(
                  'Forgot password',
                  style: LightTextTheme.clickableTxt,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(formKey.currentState!.validate()) {
                    LoginController.instance.loginUser(
                      controller.email.text.trim(),
                      controller.password.text.trim()
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor
                ),
                child: const Text(
                  'Login',
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