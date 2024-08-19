import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/inkgram_service.dart';
import '../../service/tts_service.dart';

class InkgramCommentFull extends StatefulWidget {
  final String postId;
  final String userId;

  InkgramCommentFull({super.key, required this.postId, required this.userId});

  @override
  State<InkgramCommentFull> createState() => _InkgramCommentFullState();
}

class _InkgramCommentFullState extends State<InkgramCommentFull> {
  final TtsService ttsService = TtsService();
  final TextEditingController _commentController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final Map<String, bool> _repliesVisibility = {};

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void toggleRepliesVisibility(String commentId) {
    setState(() {
      _repliesVisibility[commentId] = !(_repliesVisibility[commentId] ?? false);
    });
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

  void showReplyTextField(String commentId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController replyController = TextEditingController();
        InkgramService inkgramService = InkgramService(userId: currentUserId);

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
              top: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    decoration: InputDecoration(
                      hintText: 'Add a reply...',
                      border: InputBorder.none,
                      hintStyle: LightTextTheme.inkgramComment,
                    ),
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        await inkgramService.addReply(widget.postId, commentId,
                            value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: primaryColor),
                  onPressed: () async {
                    if (replyController.text.isNotEmpty) {
                      await inkgramService.addReply(widget.postId, commentId,
                          replyController.text);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteReplyConfirmationDialog(
      BuildContext context, String postId, String commentId, String replyId)
  async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Reply?',
          style: LightTextTheme.deleteBtn,
        ),
        content: Text(
          'Are you sure you want to delete this reply?',
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
                  .deleteReply(postId, commentId, replyId);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Comments',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: Column(
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
                  return const Center(
                      child: CircularProgressIndicatorTheme());
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
                              showReplyTextField(commentId);
                            },
                            child: Text(
                              'Reply',
                              style: LightTextTheme.replyBtn,
                            ),
                          ),
                          // StreamBuilder for Replies
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userId)
                                .collection('inkgram')
                                .doc(widget.postId)
                                .collection('comments')
                                .doc(commentId)
                                .collection('replies')
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot>
                            replySnapshot) {
                              if (!replySnapshot.hasData || replySnapshot.data
                              !.docs.isEmpty) {
                                return Container();
                              }

                              bool isVisible = _repliesVisibility[commentId] ??
                                  false;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () => toggleRepliesVisibility
                                      (commentId),
                                    child: Text(
                                      isVisible ? 'Hide Replies' : 'Show '
                                          'Replies',
                                      style: LightTextTheme.replyBtn,
                                    ),
                                  ),
                                  if (isVisible)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: replySnapshot.data!.docs.map(
                                              (replyDoc) {
                                        var replyData = replyDoc.data() as Map
                                        <String, dynamic>;
                                        String replyId = replyDoc.id;

                                        return Padding(
                                          padding: const EdgeInsets.symmetric
                                            (vertical: 4.0),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      replyData['username'],
                                                      style: LightTextTheme
                                                          .inkgramCommentUser,
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      replyData['reply'],
                                                      style: LightTextTheme
                                                          .inkgramComment,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment
                                                    .centerRight,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    IconButton(
                                                      iconSize: 18.0,
                                                      icon: const Icon(
                                                        Icons.volume_up,
                                                        color: primaryColor,
                                                      ),
                                                      onPressed: () {
                                                        ttsService.speak(
                                                            replyData['reply']);
                                                      },
                                                    ),
                                                    if (currentUserId ==
                                                        replyData['userId'] ||
                                                        currentUserId == widget
                                                            .userId)
                                                      IconButton(
                                                        iconSize: 18.0,
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red
                                                        ),
                                                        onPressed: () {
                                                          showDeleteReplyConfirmationDialog(
                                                            context,
                                                            widget.postId,
                                                            commentId,
                                                            replyId
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              );
                            },
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
                      await addComment(
                          widget.userId, widget.postId, _commentController
                          .text);
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
