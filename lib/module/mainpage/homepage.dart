import 'package:InklusiveDraw/module/drawing_practice/drawing/drawing_page'
    '.dart';
import 'package:InklusiveDraw/module/support_and_resources/community/'
    'community_screen.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'drawer_content.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: const DrawerContent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'InklusiveDraw',
              style: LightTextTheme.appName,
            ),
            const SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // go to Gallery
                          //Get.to(DrawingScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                        ),
                        child: const Icon(
                          LineAwesomeIcons.photo_video_solid,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "My Gallery",
                        style: LightTextTheme.textName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // go to Drawing Canvas
                          Get.to(DrawingPage());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                        ),
                        child: const Icon(
                          LineAwesomeIcons.pencil_alt_solid,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Draw",
                        style: LightTextTheme.textName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // go to Community screen
                          Get.to(const CommunityScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                        ),
                        child: const Icon(
                          LineAwesomeIcons.people_carry_solid,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Community",
                        style: LightTextTheme.textName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
