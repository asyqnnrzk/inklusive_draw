import 'package:InklusiveDraw/module/inkgram/inkgram_homepage.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/inkgram_service.dart';
import '../../source/image_strings.dart';
import '../../source/progress_indicator_theme.dart';
import '../../source/text_theme.dart';
import '../user_auth_and_profile/profile/update_profile_screen.dart';
import 'inkgram_post.dart';

class InkgramProfile extends StatefulWidget {
  const InkgramProfile({super.key});

  @override
  State<InkgramProfile> createState() => _InkgramProfileState();
}

class _InkgramProfileState extends State<InkgramProfile> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 3;

  Future<Map<String, dynamic>> getUserProfileData(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
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

  void _onItemTapped(int index) {
    if (index == 0) {
      Get.to(() => const InkgramHomepage());
    } else if (index == 2) {
      showCreatePostDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserProfileData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicatorTheme()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(LineAwesomeIcons.angle_left_solid),
              ),
              title: const Text('Username'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(LineAwesomeIcons.angle_left_solid),
              ),
              title: const Text('No Data'),
            ),
            body: const Center(child: Text('No user data found')),
          );
        } else {
          var userData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(LineAwesomeIcons.angle_left_solid),
              ),
              title: Text(
                userData['name'] ?? 'Username',
                style: LightTextTheme.pageHeadline,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userData['avatar'] ?? userDefault,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    userDefault,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => Get.to(() => const
                                UpdateProfileScreen()),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: primaryColor,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
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
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  _buildStatColumn("Posts", userData['posts'] ?? 0),
                                  _buildStatColumn("Followers", userData['followers'] ?? 0),
                                  _buildStatColumn("Following", userData['following'] ?? 0),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryColor
                                  ),
                                  onPressed: () => Get.to(() => const
                                  UpdateProfileScreen()),
                                  child: Text(
                                    'Edit profile',
                                    style: LightTextTheme.profileTxt,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData['name'] ?? 'No data',
                            style: LightTextTheme.profileTxtBold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData['bio'] ?? 'No data',
                            style: LightTextTheme.profileTxt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Grid view for posts
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('inkgram')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicatorTheme();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.docs
                          .isEmpty) {
                        return const Text('No posts yet');
                      } else {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            final imageUrl = post['picture'];
                            final description = post['description'];

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => InkgramPost(
                                  postId: post.id,
                                  imageUrl: imageUrl,
                                  description: description,
                                ));
                              },
                              child: Container(
                                color: Colors.grey[300],
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: primaryColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box),
                  label: 'Create',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: secondaryColor,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
          );
        }
      },
    );
  }

  Column _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}
