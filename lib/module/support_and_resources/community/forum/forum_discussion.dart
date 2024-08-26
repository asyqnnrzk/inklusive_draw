import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../service/tts_service.dart';
import '../../../../source/text_theme.dart';

class ForumDiscussion extends StatefulWidget {
  final String postId;
  final String communityId;

  ForumDiscussion({required this.postId, required this.communityId});

  @override
  _ForumDiscussionState createState() => _ForumDiscussionState();
}

class _ForumDiscussionState extends State<ForumDiscussion> {
  final TextEditingController _commentController = TextEditingController();
  final TtsService _ttsService = TtsService();

  Future<void> _addComment(String content) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the username from the user's profile
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final username = userDoc.get('username');

    // Add the comment with username
    await FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .collection('forum')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'content': content,
      'authorId': userId,
      'authorUsername': username,
      'timestamp': Timestamp.now(),
    });
  }

  void _sendComment() {
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      _addComment(content);
      _commentController.clear();
    }
  }

  Future<void> _deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .collection('forum')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  void _readPost(String title, String content) async {
    await _ttsService.speak('$title. $content');
  }

  void _readComment(String content) async {
    await _ttsService.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discussion',
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
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('communities')
                .doc(widget.communityId)
                .collection('forum')
                .doc(widget.postId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicatorTheme());
              }
              if (!snapshot.hasData) {
                return Center(child: Text(
                  'Post not found.',
                  style: LightTextTheme.forumLabel,
                ));
              }

              final post = snapshot.data!;
              return Container(
                color: greenButton,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            post['title'],
                            style: LightTextTheme.forumTitle,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          iconSize: 16.0,
                          color: primaryColor,
                          onPressed: () => _readPost(post['title'],
                              post['content']),
                          tooltip: 'Read Aloud',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post['content'],
                      style: LightTextTheme.forumLabel,
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('communities')
                  .doc(widget.communityId)
                  .collection('forum')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicatorTheme());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text(
                    'Be the first to comment!',
                    style: LightTextTheme.forumLabel,
                  ));
                }

                final comments = snapshot.data!.docs;
                if (comments.isEmpty) {
                  return Center(child: Text(
                    'Be the first to comment!',
                    style: LightTextTheme.forumLabel,
                  ));
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final commentId = comment.id;
                    final authorId = comment['authorId'];
                    final currentUserId = FirebaseAuth.instance.currentUser!
                        .uid;

                    return ListTile(
                      title: Text(
                        comment['content'],
                        style: LightTextTheme.forumLabel,
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'by ${comment['authorUsername']}',
                              style: LightTextTheme.forumBy,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            iconSize: 16.0,
                            color: primaryColor,
                            onPressed: () => _readComment(comment['content']),
                            tooltip: 'Read Aloud',
                          ),
                        ],
                      ),
                      trailing: currentUserId == authorId ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        iconSize: 16.0,
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Delete Comment?',
                                  style: LightTextTheme.deleteBtn,
                                ),
                                content: Text(
                                  'Delete this comment?',
                                  style: LightTextTheme.reportDetails,
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: LightTextTheme.cancelBtn,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Delete',
                                      style: LightTextTheme.deleteBtn,
                                    ),
                                    onPressed: () async {
                                      await _deleteComment(commentId);
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ) : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      labelStyle: LightTextTheme.forumLabel,
                      suffixIcon: IconButton(
                        icon: const Icon(
                            Icons.send_rounded, color: primaryColor
                        ),
                        onPressed: _sendComment,
                      ),
                    ),
                    onSubmitted: (value) {
                      _sendComment();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
