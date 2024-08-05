import 'package:InklusiveDraw/controller/notification_service_controller.dart';
import 'package:InklusiveDraw/firebase_options.dart';
import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/notifications/'
    'notification.dart';
import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if(message.notification != null) {
    print('Some notifications received in the background');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthRepository()));

  // initialize firebase messaging
  await PushNotifications.init();

  // initialize local notifications
  await PushNotifications.localNotiInit();
  
  // listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if(message.notification != null) {
      print('Background notification tapped');
      navigatorKey.currentState!.pushNamed('/notification', arguments: message);
    }
  });

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
      navigatorKey: navigatorKey,
      getPages: [
        GetPage(name: '/notification', page: () => const NotificationScreen())
      ],
      home: const Scaffold(
        backgroundColor: secondaryColor,
        body: Center(
          child: Homepage()
        ),
      ),
    );
  }
}
