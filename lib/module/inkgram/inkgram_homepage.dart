import 'package:InklusiveDraw/module/inkgram/inkgram_comment.dart';
import 'package:InklusiveDraw/module/inkgram/inkgram_notifications.dart';
import 'package:InklusiveDraw/module/inkgram/inkgram_profile.dart';
import 'package:InklusiveDraw/module/inkgram/inkgram_search.dart';
import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/source/report_button.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../model/notification_model.dart';
import '../../service/inkgram_service.dart';
import '../../source/colors.dart';

class InkgramHomepage extends StatefulWidget {
  const InkgramHomepage({super.key});

  @override
  State<InkgramHomepage> createState() => _InkgramHomepageState();
}

class _InkgramHomepageState extends State<InkgramHomepage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    List<Map<String, dynamic>> posts = [];

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print('User not authenticated');
      return posts;
    }

    final userId = currentUser.uid;

    QuerySnapshot userSnapshot = await _firestore.collection('users').get();

    for (var userDoc in userSnapshot.docs) {
      QuerySnapshot postSnapshot = await _firestore
          .collection('users')
          .doc(userDoc.id)
          .collection('inkgram')
          .get();

      for (var postDoc in postSnapshot.docs) {
        Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
        postData['username'] = userDoc['username'];
        postData['userId'] = userDoc.id;
        postData['postId'] = postDoc.id;

        // Check if the current user has liked this post
        final likeDoc = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('inkgram')
            .doc(postDoc.id)
            .collection('likes')
            .doc(userId)
            .get();

        postData['isLiked'] = likeDoc.exists;

        posts.add(postData);
      }
    }

    return posts;
  }

  Future<String?> _getCurrentUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      return userData?['username'] as String?;
    }
    return null;
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Get.to(() => const InkgramSearch());
    } else if (index == 2) {
      showCreatePostDialog(context);
    } else if (index == 3) {
      Get.to(() => const InkgramNotifications());
    } else if (index == 4) {
      Get.to(() => InkgramProfile(userId: FirebaseAuth.instance
          .currentUser!.uid));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _toggleLike(String postId, String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print('User not authenticated');
      return;
    }

    final currentUserName = await _getCurrentUserName();
    if (currentUserName == null) {
      print('Current user username not found');
      return;
    }

    final likeId = currentUser.uid;

    final likesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('inkgram')
        .doc(postId)
        .collection('likes')
        .doc(likeId);

    final postRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('inkgram')
        .doc(postId);

    try {
      final likeDoc = await likesRef.get();

      if (likeDoc.exists) {
        // Un-like
        await likesRef.delete();
        await postRef.update({
          'likes': FieldValue.increment(-1),
        });
        print('Unliked post');
      } else {
        // Like
        await likesRef.set({
          'userId': likeId,  // The user who liked the post
          'username': currentUserName,
          'timestamp': Timestamp.now(),
        });
        await postRef.update({
          'likes': FieldValue.increment(1),
        });

        // Create a notification for the post owner
        await _createLikeNotification(
          postId,
          userId,
          currentUserName,
        );

        print('Liked post');
      }

      // Refresh the UI state to reflect the like/unlike change
      setState(() {});
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> _createLikeNotification(String postId, String userId,
      String username) async {
    final notificationsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc();

    final notification = NotificationModel(
      id: notificationsRef.id,
      userId: FirebaseAuth.instance.currentUser!.uid,
      postId: postId,
      username: username,
      type: 'like',
      timestamp: Timestamp.now(),
    );

    print('Creating notification with data: ${notification.toMap()}');

    await notificationsRef.set(notification.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const Homepage());
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'InkGram',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          List<Map<String, dynamic>> posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> post = posts[index];

              bool isLiked = post['isLiked'] ?? false;

              return Card(
                color: tertiaryColor,
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => InkgramProfile(
                                  userId: post['userId']
                              ));
                            },
                            child: Text(
                              post['username'] ?? 'Unknown User',
                              style: LightTextTheme.inkgramPostUser,
                            ),
                          ),
                          const Spacer(),
                          const ReportButton()
                        ],
                      ),
                    ),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(post['picture']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            post['description'] ?? 'No description',
                            style: LightTextTheme.inkgramPostDesc,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: 'Like the post',
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.
                                  favorite_border,
                                  color: isLiked ? Colors.red : blackColor,
                                ),
                                onPressed: () {
                                  _toggleLike(post['postId'], post['userId']);
                                },
                              ),
                              IconButton(
                                tooltip: 'Comment something',
                                icon: const Icon(Icons.comment),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SizedBox(
                                      height: MediaQuery.of(context)
                                          .size.height * 0.5,
                                      child: InkgramComment(
                                        postId: post['postId'],
                                        userId: post['userId'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
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
}
