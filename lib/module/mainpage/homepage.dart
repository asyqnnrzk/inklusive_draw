import 'package:InklusiveDraw/module/drawing_practice/drawing_screen.dart';
import 'package:InklusiveDraw/module/support_and_resources/community/community_screen.dart';
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
            color: Colors.white
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // go to Gallery
                        // let's redirect to canvas for now
                        Get.to(DrawingScreen());
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(24)
                      ),
                      child: const Icon(
                        LineAwesomeIcons.brush_solid,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                        "My Gallery",
                        style: LightTextTheme.textName
                    ),
                  ],
                ),
                const SizedBox(height: 36.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // go to Exercise Canvas
                        Get.to(DrawingScreen());
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(24)
                      ),
                      child: const Icon(
                        LineAwesomeIcons.dumbbell_solid,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                        "Exercise",
                        style: LightTextTheme.textName
                    ),
                  ],
                ),
                const SizedBox(height: 36.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(CommunityScreen());
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(24)
                      ),
                      child: const Icon(
                        LineAwesomeIcons.people_carry_solid,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                        "Community",
                        style: LightTextTheme.textName
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

