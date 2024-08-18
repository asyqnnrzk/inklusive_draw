import 'package:InklusiveDraw/module/inkgram/inkgram_comment.dart';
import 'package:InklusiveDraw/module/inkgram/inkgram_profile.dart';
import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/source/buttons.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
        posts.add(postData);
      }
    }

    return posts;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      showCreatePostDialog(context);
    } else if (index == 3) {
      Get.to(() => InkgramProfile(userId: FirebaseAuth.instance
          .currentUser!.uid));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
                                  setState(() {
                                    isLiked = !isLiked;
                                    // Update the post in Firestore
                                    _firestore
                                        .collection('users')
                                        .doc(post['userId'])
                                        .collection('inkgram')
                                        .doc(post['postId'])
                                        .update({
                                          'isLiked': isLiked,
                                          'likes': isLiked
                                              ? FieldValue.increment(1)
                                              : FieldValue.increment(-1)
                                    });
                                  });
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
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: InkgramComment(postId: post['postId'], userId: post['userId'],),
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
}
