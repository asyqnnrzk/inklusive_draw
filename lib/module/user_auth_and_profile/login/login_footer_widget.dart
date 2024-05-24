import 'package:InklusiveDraw/module/user_auth_and_profile/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../source/colors.dart';
import '../../../source/image_strings.dart';
import '../../../source/text_theme.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'OR',
          style: TextStyle(
              color: blackColor,
              fontFamily: 'MontserratBold'
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {

            },
            icon: const Image(
              image: AssetImage(googleLogo),
              width: 20,
            ),
            label: const Text(
              'Continue with Google',
              style: TextStyle(
                  color: blackColor
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const RegisterScreen());
          },
          child: Text(
            "Don't have account? Register",
            style: LightTextTheme.clickableTxt,
          ),
        )
      ],
    );
  }
}