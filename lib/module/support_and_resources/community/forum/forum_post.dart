import 'package:InklusiveDraw/source/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../source/text_theme.dart';

class ForumPost extends StatefulWidget {
  final String communityId;

  ForumPost({required this.communityId});

  @override
  _ForumPostState createState() => _ForumPostState();
}

class _ForumPostState extends State<ForumPost> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _submitPost() async {
    // Get the current user's UID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Check if the title or content fields are empty
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Title and content cannot be empty!',
            style: LightTextTheme.forumLabel,
          ),
          backgroundColor: redButton,
        ),
      );
      return;
    }

    if (userId != null) {
      // Fetch the user's data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String username = userDoc.get('username');

      // Use the communityId passed to the widget
      await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .collection('forum')
          .add({
        'authorId': userId,
        'author': username,
        'title': _titleController.text,
        'content': _contentController.text,
        'timestamp': Timestamp.now(),
      });

      Navigator.pop(context);
    } else {
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post something',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: LightTextTheme.forumLabel
              ),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: LightTextTheme.forumLabel
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text(
                'Submit',
                style: LightTextTheme.submitBtn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
