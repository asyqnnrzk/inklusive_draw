import 'package:InklusiveDraw/module/inkgram/inkgram_likes.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../service/tts_service.dart';
import 'inkgram_comment_full.dart';

class InkgramPost extends StatelessWidget {
  final String postId;
  final String imageUrl;
  final String description;
  final String userId; // Add userId here

  const InkgramPost({
    Key? key,
    required this.postId,
    required this.imageUrl,
    required this.description,
    required this.userId, // Initialize userId
  }) : super(key: key);

  Future<void> _deletePost(BuildContext context) async {
    // userId is now accessible here

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Post?',
          style: LightTextTheme.reportBtn,
        ),
        content: Text(
          'Are you sure you want to delete this post?',
          style: LightTextTheme.reportDetails,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: LightTextTheme.cancelBtn,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: LightTextTheme.deleteBtn,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Delete the post from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('inkgram')
            .doc(postId)
            .delete();

        // Delete the post image from Firebase Storage
        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();

        // Decrease the post count in the user's profile
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('profile')
            .doc(userId)
            .update({
          'posts': FieldValue.increment(-1),
        });

        // Optionally, navigate back or show a success message
        Get.back();
        Get.snackbar('Success', 'Post deleted successfully');
      } catch (e) {
        // Handle errors
        Get.snackbar('Error', 'Failed to delete post: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TtsService ttsService = TtsService();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        actions: [
          IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () => _deletePost(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    description,
                    style: LightTextTheme.inkgramPostDesc,
                  ),
                  IconButton(
                    color: primaryColor,
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      ttsService.speak(description);
                    },
                  ),
                  const Spacer(),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('inkgram')
                        .doc(postId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text('Post not found');
                      } else {
                        final postData = snapshot.data!.data() as Map<String, dynamic>;
                        final likeCount = postData['likes'] ?? 0;
                        final commentCount = postData['comments'] ?? 0;

                        return Row(
                          children: [
                            IconButton(
                              color: Colors.red,
                              icon: Row(
                                children: [
                                  const Icon(Icons.favorite),
                                  const SizedBox(width: 4.0),
                                  Text(likeCount.toString()),
                                ],
                              ),
                              onPressed: () {
                                Get.to(() => InkgramLikes(
                                  postId: postId,
                                  userId: userId,
                                ));
                              },
                            ),
                            IconButton(
                              color: primaryColor,
                              icon: Row(
                                children: [
                                  const Icon(Icons.comment),
                                  const SizedBox(width: 4.0),
                                  Text(commentCount.toString()),
                                ],
                              ),
                              onPressed: () {
                                Get.to(() => InkgramCommentFull(
                                  postId: postId,
                                  userId: userId,
                                ));
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
