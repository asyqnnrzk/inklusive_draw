import 'package:flutter/material.dart';
import '../../../source/text_theme.dart';
import 'forget_password_widget.dart';

void ForgetPasswordBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            Text(
              'Reset your password',
              style: LightTextTheme.forgetPassword,
            ),
            const SizedBox(height: 16),
            const ForgetPasswordWidget()
          ],
        )
    ),
  );
}