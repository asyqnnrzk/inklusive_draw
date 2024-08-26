import 'package:InklusiveDraw/source/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../source/text_theme.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ForumPost extends StatefulWidget {
  final String communityId;

  ForumPost({required this.communityId});

  @override
  _ForumPostState createState() => _ForumPostState();
}

class _ForumPostState extends State<ForumPost> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage
      (source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('forum_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _submitPost() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

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

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String username = userDoc.get('username');

      await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .collection('forum')
          .add({
        'authorId': userId,
        'author': username,
        'title': _titleController.text,
        'content': _contentController.text,
        'imageUrl': imageUrl,
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
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(height: 10),
              if (_selectedImage != null)
                Image.file(_selectedImage!),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(
                  'Upload Image',
                  style: LightTextTheme.submitBtn,
                ),
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
      ),
    );
  }
}
