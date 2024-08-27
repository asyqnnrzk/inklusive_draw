import 'package:InklusiveDraw/module/inkgram/inkgram_homepage.dart';
import 'package:InklusiveDraw/module/inkgram/inkgram_search.dart';
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
  final String userId;

  const InkgramProfile({super.key, required this.userId});

  @override
  State<InkgramProfile> createState() => _InkgramProfileState();
}

class _InkgramProfileState extends State<InkgramProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 3;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  Future<String?> getProfileId(String userId) async {
    final profileDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .get();

    if (profileDocs.docs.isNotEmpty) {
      return profileDocs.docs.first.id;
    } else {
      return null;
    }
  }

  Future<String?> getFollowingUserName(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users')
        .doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      return data?['username'] as String?;
    }
    return null;
  }

  Future<String?> getFollowerUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users')
          .doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return data?['username'] as String?;
      }
    }
    return null;
  }

  Future<void> checkIfFollowing() async {
    final profileId = await getProfileId(currentUser.uid);

    if (profileId == null) {
      print('Profile ID not found');
      return;
    }

    final followDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('profile')
        .doc(profileId)
        .collection('following')
        .doc(widget.userId)
        .get();

    print('Following Document Exists: ${followDoc.exists}');
    setState(() {
      isFollowing = followDoc.exists;
    });
  }

  Future<void> followOrUnfollow() async {
    // Get the profile ID of the person you're following
    final followingProfileId = await getProfileId(widget.userId);
    if (followingProfileId == null) {
      print('Following profile ID not found');
      return;
    }

    // Get the profile ID of the current user (follower)
    final followerProfileId = await getProfileId(currentUser.uid);
    if (followerProfileId == null) {
      print('Follower profile ID not found');
      return;
    }

    // Get usernames
    final followingUserName = await getFollowingUserName(widget.userId);
    final followerUserName = await getFollowerUserName();

    if (followingUserName == null || followerUserName == null) {
      print('Username not found');
      return;
    }

    // Reference to the follower collection (target user who is being followed)
    final followerRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('profile')
        .doc(followingProfileId)
        .collection('followers')
        .doc(currentUser.uid);

    // Reference to the following collection (current user who is following)
    final followingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('profile')
        .doc(followerProfileId)
        .collection('following')
        .doc(widget.userId);

    // Reference to update follower and following counts
    final followerCountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('profile')
        .doc(followingProfileId); // The profile of the person being followed

    final followingCountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('profile')
        .doc(followerProfileId); // The profile of the current user (follower)

    try {
      if (isFollowing) {
        // Unfollow
        await followingRef.delete();
        await followerRef.delete();
        print('Unfollowed successfully');

        // Decrease follower and following counts
        await followerCountRef.update({'followers': FieldValue.increment(-1)});
        await followingCountRef.update({'following': FieldValue.increment(-1)});
      } else {
        // Follow
        await followingRef.set({
          'userId': widget.userId,
          'userName': followingUserName,
        });
        print('Following added');

        await followerRef.set({
          'userId': currentUser.uid,
          'userName': followerUserName,
        });
        print('Follower added');

        // Increase follower and following counts
        await followerCountRef.update({'followers': FieldValue.increment(1)});
        await followingCountRef.update({'following': FieldValue.increment(1)});
      }

      setState(() {
        isFollowing = !isFollowing;
      });
    } catch (e) {
      print('Error during follow/unfollow operation: $e');
    }
  }

  Future<Map<String, dynamic>> getUserProfileData(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users')
        .doc(userId).get();
    final profileDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .get();

    if (profileDoc.docs.isNotEmpty) {
      var profileData = profileDoc.docs.first.data();
      print('Profile Data: $profileData');
    } else {
      print('No profile data found');
    }

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
    } else if (index == 1) {
      Get.to(() => const InkgramSearch());
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
      future: getUserProfileData(widget.userId),
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
                                  _buildStatColumn("Posts", userData['posts']
                                      ?? 0),
                                  _buildStatColumn("Followers", userData
                                  ['followers'] ?? 0),
                                  _buildStatColumn("Following", userData
                                  ['following'] ?? 0),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Show Follow/Unfollow or Edit profile button
                              Center(
                                child: widget.userId == currentUser.uid
                                    ? TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryColor,
                                  ),
                                  onPressed: () => Get.to(() => const
                                  UpdateProfileScreen()),
                                  child: Text(
                                    'Edit profile',
                                    style: LightTextTheme.profileTxt,
                                  ),
                                )
                                    : TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: isFollowing ? Colors.grey
                                        : primaryColor,
                                  ),
                                  onPressed: followOrUnfollow,
                                  child: Text(
                                    isFollowing ? 'Unfollow' : 'Follow',
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
                        .doc(widget.userId)
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
                        return Text(
                          'Start create new post!',
                          style: LightTextTheme.inkgramPostDesc,
                        );
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
                            final imageUrl = post['picture'];
                            final description = post['description'];

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => InkgramPost(
                                  userId: widget.userId,
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
