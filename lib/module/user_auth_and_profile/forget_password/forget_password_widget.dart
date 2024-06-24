import 'package:InklusiveDraw/module/user_auth_and_profile/forget_password/'
    'forget_password_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Get.to(() => const ForgetPasswordEmail());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: greyColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email,
              size: 60,
            ),
            const SizedBox(width: 8),
            Text(
              'Send email',
              style: LightTextTheme.resetWithEmail,
            )
          ],
        ),
      ),
    );
  }
}
