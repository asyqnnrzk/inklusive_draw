import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class UserSearch extends StatelessWidget {
  const UserSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(
                      width: 4,
                      color: primaryColor
                  )
              )
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search',
                style: LightTextTheme.dashboardHeadline.apply(
                    color: Colors.grey.withOpacity(0.5)
                ),
              ),
              const Icon(
                Icons.mic,
                size: 25,
                color: primaryColor,
              )
            ],
          ),
        ),
      ],
    );
  }
}
