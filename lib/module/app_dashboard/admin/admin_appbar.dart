import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/image_strings.dart';
import '../../../source/text_theme.dart';
import '../../mainpage/homepage.dart';
import '../../user_auth_and_profile/profile/profile_screen.dart';

class AdminDashboardAppbar extends StatefulWidget implements PreferredSizeWidget
{
  const AdminDashboardAppbar({super.key});

  @override
  _AdminDashboardAppbarState createState() => _AdminDashboardAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _AdminDashboardAppbarState extends State<AdminDashboardAppbar> {
  String? avatarUrl;
  String? userId;
  String? profileId;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    userId = await getUserIdFromFirebase();
    if (userId != null) {
      profileId = await getProfileIdFromFirebase(userId!);
    }

    if (userId != null && profileId != null) {
      fetchUserAvatar();
    } else {
      setState(() {
        avatarUrl = userDefault;
      });
    }
  }

  Future<String?> getUserIdFromFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<String?> getProfileIdFromFirebase(String userId) async {
    try {
      QuerySnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile')
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        return profileSnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching profileId: $e");
      return null;
    }
  }

  Future<void> fetchUserAvatar() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc(profileId)
          .get();

      setState(() {
        avatarUrl = userDoc['avatar'] ?? userDefault;
      });
    } catch (e) {
      setState(() {
        avatarUrl = userDefault;
      });
      print("Error fetching avatar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.to(() => const Homepage());
        },
        icon: const Icon(LineAwesomeIcons.angle_left_solid),
      ),
      title: Text(
          'InklusiveDraw',
          style: LightTextTheme.pageHeadline
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(const ProfileScreen());
          },
          icon: avatarUrl != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) => const Image(
                image: AssetImage(userDefault),
              ),
            ),
          )
              : const Image(
            image: AssetImage(userDefault),
          ),
        )
      ],
    );
  }
}
