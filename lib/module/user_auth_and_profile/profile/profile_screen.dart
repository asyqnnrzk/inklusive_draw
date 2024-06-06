import 'package:InklusiveDraw/module/user_auth_and_profile/profile/profile_menu.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/profile/update_profile_screen.dart';
import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/image_strings.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Profile',
          style: LightTextTheme.profileHeadline,
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(
              isDark ? LineAwesomeIcons.sun :
                  LineAwesomeIcons.moon
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage(
                          userDefault
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor
                      ),
                      child: const Icon(
                        LineAwesomeIcons.pencil_alt_solid,
                        size: 20,
                        color: Colors.white70,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Asyiqin Razak',
                style: LightTextTheme.profileTxtBold,
              ),
              Text(
                'asyqnnrzk',
                style: LightTextTheme.profileTxt,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // menu
              ProfileMenuWidget(title: 'Settings', icon: LineAwesomeIcons.cog_solid, onPress: (){}),
              ProfileMenuWidget(title: 'Notifications', icon: Icons.notifications_none, onPress: (){}),
              ProfileMenuWidget(title: 'Dashboard', icon: Icons.dashboard_outlined, onPress: (){}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: 'Information', icon: LineAwesomeIcons.info_circle_solid, onPress: (){}),
              ProfileMenuWidget(
                title: 'Logout',
                icon: LineAwesomeIcons.sign_out_alt_solid,
                textColor: Colors.red,
                endIcon: false,
                onPress: (){
                  AuthRepository().logout();
                }),
            ],
          ),
        ),
      ),
    );
  }
}
