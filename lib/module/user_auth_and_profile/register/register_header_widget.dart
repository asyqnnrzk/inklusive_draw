import 'package:flutter/material.dart';
import '../../../source/text_theme.dart';

class RegisterHeaderWidget extends StatelessWidget {
  const RegisterHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'InklusiveDraw',
          style: LightTextTheme.appName,
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          'Register',
          style: LightTextTheme.subName,
        ),
      ],
    );
  }
}
