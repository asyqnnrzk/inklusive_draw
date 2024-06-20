import 'package:InklusiveDraw/module/user_auth_and_profile/profile/profile_menu.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/profile/update_profile_screen.dart';
import 'package:InklusiveDraw/repository/auth_repository.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/image_strings.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, dynamic>> getUserProfileData(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final profileDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .get();

    if (userDoc.exists && profileDoc.docs.isNotEmpty) {
      return {
        ...userDoc.data()!,
        ...profileDoc.docs.first.data(),
      };
    } else {
      throw Exception('User or profile not found');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserProfileData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No user data found'));
          } else {
            var userData = snapshot.data!;
            return SingleChildScrollView(
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
                            child: Image.network(
                              userData['avatar'] ?? userDefault,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  userDefault,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => Get.to(() => const UpdateProfileScreen()),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: primaryColor,
                              ),
                              child: const Icon(
                                LineAwesomeIcons.pencil_alt_solid,
                                size: 20,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['name'] ?? 'No data',
                      style: LightTextTheme.profileTxtBold,
                    ),
                    Text(
                      userData['username'] ?? 'No data',
                      style: LightTextTheme.profileTxt,
                    ),
                    Text(
                      userData['bio'] ?? 'No data',
                      style: LightTextTheme.profileTxt,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const UpdateProfileScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
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
                    ProfileMenuWidget(
                        title: 'Settings',
                        icon: LineAwesomeIcons.cog_solid,
                        onPress: (){}
                    ),
                    ProfileMenuWidget(
                        title: 'Notifications',
                        icon: Icons.notifications_none,
                        onPress: (){}
                    ),
                    ProfileMenuWidget(
                        title: 'Dashboard',
                        icon: Icons.dashboard_outlined,
                        onPress: (){}
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                      title: 'Logout',
                      icon: LineAwesomeIcons.sign_out_alt_solid,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: redText
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Dismiss the dialog
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: primaryColor
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Dismiss the dialog
                                    AuthRepository().logout(); // Perform the logout
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
