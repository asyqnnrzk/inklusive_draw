import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../service/inkgram_service.dart';
import '../../service/tts_service.dart';

class InkgramComment extends StatefulWidget {
  final String postId;
  final String userId;

  InkgramComment({required this.postId, required this.userId});

  @override
  State<InkgramComment> createState() => _InkgramCommentState();
}

class _InkgramCommentState extends State<InkgramComment> {
  final TtsService ttsService = TtsService();
  final TextEditingController _commentController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> showDeleteConfirmationDialog(String commentId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Comment?',
          style: LightTextTheme.deleteBtn,
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: LightTextTheme.reportDetails,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: LightTextTheme.cancelBtn,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await InkgramService(userId: widget.userId)
                  .deleteComment(widget.postId, commentId);
            },
            child: Text(
              'Delete',
              style: LightTextTheme.deleteBtn,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 6.0,
          width: 50.0,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(3.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .collection('inkgram')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicatorTheme());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No comments yet',
                    style: LightTextTheme.inkgramComment,
                  ),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  var commentData = doc.data() as Map<String, dynamic>;
                  String commentId = doc.id;
                  String commentOwnerId = commentData['userId'];

                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentData['username'],
                          style: LightTextTheme.inkgramCommentUser,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          commentData['comment'],
                          style: LightTextTheme.inkgramComment,
                          maxLines: null,
                          softWrap: true,
                        ),
                        const SizedBox(height: 4.0),
                        TextButton(
                          onPressed: () {
                            // Handle reply action
                          },
                          child: Text(
                            'Reply',
                            style: LightTextTheme.replyBtn,
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            iconSize: 18.0,
                            icon: const Icon(
                              Icons.volume_up,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              ttsService.speak(commentData['comment']);
                            },
                          ),
                          if (currentUserId == commentOwnerId ||
                              currentUserId == widget.userId)
                            IconButton(
                              iconSize: 18.0,
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDeleteConfirmationDialog(commentId);
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: InputBorder.none,
                    hintStyle: LightTextTheme.inkgramComment,
                  ),
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await addComment(widget.userId, widget.postId, value);
                      _commentController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: primaryColor),
                onPressed: () async {
                  if (_commentController.text.isNotEmpty) {
                    await addComment(widget.userId, widget.postId, _commentController.text);
                    _commentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
