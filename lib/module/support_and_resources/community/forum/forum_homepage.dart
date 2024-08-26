import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'forum_post.dart';
import 'forum_discussion.dart';
import 'post_card.dart';

class ForumHomepage extends StatelessWidget {
  final String? communityId;

  ForumHomepage({this.communityId});

  @override
  Widget build(BuildContext context) {
    print('Community ID: $communityId');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forum',
          style: LightTextTheme.pageHeadline,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('communities')
            .doc(communityId!)
            .collection('forum')
            .orderBy('timestamp', descending: true)
            .snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: LightTextTheme.dashboardTxt,
              ),
            );
          }

          final posts = snapshot.data?.docs ?? [];

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Nothing here yet?',
                    style: LightTextTheme.dashboardTxt,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Be the first to post!',
                    style: LightTextTheme.dashboardTxt,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return PostCard(
                title: post['title'] ?? 'No title',
                content: post['content'] ?? 'No content',
                author: post['author'] ?? 'Unknown',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForumDiscussion(
                        postId: post.id,
                        communityId: communityId!,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  // Delete the post from Firestore
                  await FirebaseFirestore.instance
                      .collection('communities')
                      .doc(communityId!)
                      .collection('forum')
                      .doc(post.id)
                      .delete();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (communityId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForumPost(
                  communityId: communityId!,
                ),
              ),
            );
          }
        },
        backgroundColor: greenButton,
        child: const Icon(Icons.add),
      ),
    );
  }
}
