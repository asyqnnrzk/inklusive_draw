import 'package:InklusiveDraw/module/user_auth_and_profile/register/'
    'register_screen.dart';
import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        Text(
          'OR',
          style: LightTextTheme.googleBtn,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await AuthRepository().signInUserWithGoogle();
            },
            icon: const Image(
              image: AssetImage(googleLogo),
              width: 20,
            ),
            label: Text(
              'Continue with Google',
              style: LightTextTheme.googleBtn,
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