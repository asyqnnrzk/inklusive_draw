import 'package:InklusiveDraw/module/drawing_practice/drawing/drawing_page.dart';
import 'package:InklusiveDraw/module/support_and_resources/community/community_screen.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/tts_service.dart';
import 'drawer_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TtsService _ttsService = TtsService();

  void _speak(String text) async {
    await _ttsService.speak(text);
  }

  void _onLongPress(String text) {
    _speak(text);
  }

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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildGridButton(
                    context,
                    'assets/icons/gallery.png',
                    'My Gallery',
                        () {
                      // go to Gallery
                      // Get.to(DrawingScreen());
                    },
                  ),
                  _buildGridButton(
                    context,
                    'assets/icons/color-palette.png',
                    'Draw',
                        () {
                      // go to Drawing Canvas
                      Get.to(DrawingPage());
                    },
                  ),
                  _buildGridButton(
                    context,
                    'assets/icons/community.png',
                    'Community',
                        () {
                      // go to Community screen
                      Get.to(const CommunityScreen());
                    },
                  ),
                  _buildGridButton(
                    context,
                    'assets/icons/picture.png',
                    'InkGram',
                        () {
                      // go to InkGram screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context,
      String assetPath,
      String label,
      VoidCallback onPressed,
      ) {
    return GestureDetector(
      onLongPress: () => _onLongPress(label),
      onTap: onPressed,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: primaryColor,
          padding: const EdgeInsets.all(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Image.asset(assetPath),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: LightTextTheme.labelName,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
