import 'package:InklusiveDraw/module/user_auth_and_profile/login/'
    'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/auth_repository.dart';
import '../../../source/image_strings.dart';
import '../../../source/text_theme.dart';

class RegisterFooterWidget extends StatelessWidget {
  const RegisterFooterWidget({
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
            Get.to(() => const LoginScreen());
          },
          child: Text(
            'Already have account? Login',
            style: LightTextTheme.clickableTxt,
          ),
        )
      ],
    );
  }
}