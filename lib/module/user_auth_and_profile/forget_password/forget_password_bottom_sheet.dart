import 'package:flutter/material.dart';
import '../../../source/text_theme.dart';
import 'forget_password_widget.dart';

void forgetPasswordBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reset your password',
              style: LightTextTheme.forgotPassword,
            ),
            const SizedBox(height: 16),
            const ForgetPasswordWidget(),
          ],
        ),
      ),
    ),
  );
}
