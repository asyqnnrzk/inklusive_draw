import 'package:InklusiveDraw/firebase_options.dart';
import 'package:InklusiveDraw/module/mainpage/on_board_screen.dart';
import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:InklusiveDraw/source/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthRepository()));
  runApp(const InklusiveDraw());
}

class InklusiveDraw extends StatelessWidget {
  const InklusiveDraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const CircularProgressIndicator(),
    );
  }
}
