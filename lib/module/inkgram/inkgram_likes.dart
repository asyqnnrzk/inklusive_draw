import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/tts_service.dart';

class InkgramLikes extends StatelessWidget {
  final String postId;
  final String userId;
  final TtsService ttsService = TtsService();

  InkgramLikes({required this.postId, required this.userId});

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
          'Likes',
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
                  .doc(userId)
                  .collection('inkgram')
                  .doc(postId)
                  .collection('likes')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicatorTheme());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No likes yet',
                      style: LightTextTheme.inkgramComment,
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var likesData = doc.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0
                      ),
                      child: Row(
                        children: [
                          Text(
                            likesData['username'],
                            style: LightTextTheme.inkgramCommentUser,
                          ),
                          Text(
                            ' has liked your post!',
                            style: LightTextTheme.inkgramComment,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
