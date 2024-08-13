import 'package:InklusiveDraw/module/inkgram/inkgram_homepage.dart';
import 'package:InklusiveDraw/module/inkgram/inkgram_post.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/tts_service.dart';
import '../../source/image_strings.dart';
import '../../source/progress_indicator_theme.dart';
import '../../source/text_theme.dart';

class InkgramProfile extends StatefulWidget {
  const InkgramProfile({super.key});

  @override
  State<InkgramProfile> createState() => _InkgramProfileState();
}

class _InkgramProfileState extends State<InkgramProfile> {
  final user = FirebaseAuth.instance.currentUser!;
  final TtsService _ttsService = TtsService();
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
      Get.to(() => InkgramHomepage());
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
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatColumn("Posts", "9"),
                                  _buildStatColumn("Followers", "50"),
                                  _buildStatColumn("Following", "30"),
                                ],
                              ),
                              const SizedBox(height: 10),
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
                        Text(
                          userData['name'] ?? 'No data',
                          style: LightTextTheme.profileTxtBold,
                        ),
                        Text(
                          userData['bio'] ?? 'No data',
                          style: LightTextTheme.profileTxt,
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
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
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
                          gridDelegate: const
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return Container(
                              color: Colors.grey[300],
                              child: Image.network(
                                post['picture'],
                                fit: BoxFit.cover,
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

  Column _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
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
