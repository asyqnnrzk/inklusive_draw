import 'package:flutter/material.dart';
import '../../../source/text_theme.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey,',
          style: LightTextTheme.dashboardTxt,
        ),
        Text(
          'Your dashboard',
          style: LightTextTheme.dashboardHeadline,
        ),
      ],
    );
  }
}
