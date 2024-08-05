import 'package:InklusiveDraw/module/app_dashboard/user/user_dashboard.dart';
import 'package:InklusiveDraw/module/support_and_resources/resource/'
    'resource_screen.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/profile/'
    'profile_screen.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/tts_service.dart';
import '../../source/text_theme.dart';
import '../support_and_resources/favorites/favorite_screen.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({Key? key}) : super(key: key);

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final TtsService _ttsService = TtsService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 150.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'InklusiveDraw',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 24.0,
                        fontFamily: 'MontserratBold',
                      )
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
                'Profile',
                style: LightTextTheme.textName
            ),
            onTap: () {
              // go to Profile page
              Get.to(const ProfileScreen());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person,
                  color: primaryColor,
                  size: 16,
                ),
                IconButton(
                  onPressed: (){
                    _ttsService.speak('Profile');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
                'Dashboard',
                style: LightTextTheme.textName
            ),
            onTap: () {
              // go to Dashboard page
              Get.to(const UserDashboard());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.dashboard,
                  color: primaryColor,
                  size: 16,
                ),
                IconButton(
                  onPressed: (){
                    _ttsService.speak('Dashboard');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
                'Notifications',
                style: LightTextTheme.textName
            ),
            onTap: () {
              // go to Notifications page
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.notifications,
                  color: primaryColor,
                  size: 16,
                ),
                IconButton(
                  onPressed: (){
                    _ttsService.speak('Notifications');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
                'Favorites',
                style: LightTextTheme.textName
            ),
            onTap: () {
              // go to Favorites page
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: primaryColor,
                  size: 16,
                ),
                IconButton(
                  onPressed: (){
                    _ttsService.speak('Favorites');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 16.0,
            color: Color(0xFF58B9A1),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ListTile(
            title: Text(
                'Resources',
                style: LightTextTheme.textName
            ),
            onTap: () {
              // go to Resources page
              Get.to(const ResourceScreen());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.video_collection,
                  color: primaryColor,
                  size: 16,
                ),
                IconButton(
                  onPressed: (){
                    _ttsService.speak('Resources');
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: primaryColor,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}