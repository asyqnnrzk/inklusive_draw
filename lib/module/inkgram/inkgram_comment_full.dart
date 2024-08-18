import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/inkgram_service.dart';
import '../../service/tts_service.dart';

class InkgramCommentFull extends StatefulWidget {
  final String postId;
  final String userId;

  InkgramCommentFull({required this.postId, required this.userId});

  @override
  State<InkgramCommentFull> createState() => _InkgramCommentFullState();
}

class _InkgramCommentFullState extends State<InkgramCommentFull> {
  final TtsService ttsService = TtsService();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
                    String commentOwnerId = commentData['userId']; // Assuming you store the userId of the comment owner

                    return ListTile(
                      title: Text(commentData['username']),
                      titleTextStyle: LightTextTheme.inkgramCommentUser,
                      subtitle: Text(commentData['comment']),
                      subtitleTextStyle: LightTextTheme.inkgramComment,
                      trailing: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.volume_up,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                ttsService.speak(commentData['comment']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite_border,
                                color: blackColor,
                              ),
                              onPressed: () {
                                // Handle like functionality here
                              },
                            ),
                            if (widget.userId == commentOwnerId || widget.userId == widget.userId) // Check if the user can delete
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await InkgramService(userId: widget.userId).deleteComment(widget.postId, commentId, commentOwnerId);
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
                  icon: const Icon(Icons.send_rounded),
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
      ),
    );
  }
}
