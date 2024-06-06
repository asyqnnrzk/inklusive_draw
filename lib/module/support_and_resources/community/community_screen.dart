import 'package:InklusiveDraw/module/app_dashboard/user/user_search.dart';
import 'package:InklusiveDraw/source/image_strings.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 36.0),
                Text(
                  'InklusiveDraw',
                  style: LightTextTheme.appName,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Drawing community',
                  style: LightTextTheme.subName,
                ),
                const SizedBox(height: 8.0),
                Column(
                  children: [
                    Text(
                      'Art community for dyslexic people',
                      style: LightTextTheme.regularTxt,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image(
                        image: AssetImage(
                          onBoardImage1
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const UserSearch()
              ],
            ),
          ),
        )
      ),
    );
  }
}
