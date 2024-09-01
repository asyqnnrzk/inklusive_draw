import 'package:InklusiveDraw/module/inkgram/inkgram_following_list.dart';
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
import 'inkgram_notifications.dart';
import 'inkgram_post.dart';

class InkgramProfile extends StatefulWidget {
  final String userId;

  const InkgramProfile({super.key, required this.userId});

  @override
  State<InkgramProfile> createState() => _InkgramProfileState();
}

class _InkgramProfileState extends State<InkgramProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 4;
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
    if (followingUserName == null) {
      print('Username of the user being followed not found');
      return;
    }

    // Reference to the following collection (current user who is following)
    final followingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('profile')
        .doc(followerProfileId)
        .collection('following')
        .doc(widget.userId);

    // Reference to update following counts
    final followingCountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('profile')
        .doc(followerProfileId);

    try {
      if (isFollowing) {
        // Unfollow
        await followingRef.delete();
        print('Unfollowed successfully');

        // Debugging: Check the document exists
        final doc = await followingCountRef.get();
        print('Document data before decrement: ${doc.data()}');

        // Decrease following count
        await followingCountRef.update({'following': FieldValue.increment(-1)});
        print('Following count decreased successfully');

        // Debugging: Check the updated document
        final updatedDoc = await followingCountRef.get();
        print('Document data after decrement: ${updatedDoc.data()}');
      } else {
        // Follow
        await followingRef.set({
          'userId': widget.userId,
          'userName': followingUserName,
          'timestamp': Timestamp.now()
        });
        print('Following added');

        // Increase following count
        await followingCountRef.update({'following': FieldValue.increment(1)});
        print('Following count increased successfully');
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
    } else if (index == 3) {
      Get.to(() => const InkgramNotifications());
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
              title: Text(
                'Username',
                style: LightTextTheme.pageHeadline,
              ),
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
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            final imageUrl = post['picture'];
                            final description = post['description'];
                            final likeCount = post['likes'];

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => InkgramPost(
                                  userId: widget.userId,
                                  postId: post.id,
                                  imageUrl: imageUrl,
                                  description: description,
                                ));
                              },
                              child: Column(
                                children: [
                                  Flexible(
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        color: Colors.grey[300],
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.favorite,
                                            color: Colors.red),
                                      ),
                                      Text('$likeCount')
                                    ],
                                  ),
                                ],
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
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
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
        GestureDetector(
          onTap: () {
            if (label == "Following") {
              Get.to(() => InkgramFollowingList(userId: widget.userId));
            }
          },
          child: Text(
            count.toString(),
            style: LightTextTheme.dashboardTxt,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}
