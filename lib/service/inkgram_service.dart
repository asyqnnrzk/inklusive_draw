import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InkgramService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  InkgramService({required this.userId});

  // Method to increment the post count
  Future<void> incrementPosts() async {
    try {
      await _firestore.collection('users').doc(userId)
          .collection('profile').doc(userId).update({
        'posts': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing posts: $e');
    }
  }

  // Method to increment the followers count
  Future<void> incrementFollowers() async {
    try {
      await _firestore.collection('users').doc(userId)
          .collection('profile').doc(userId).update({
        'followers': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing followers: $e');
    }
  }

  // Method to increment the following count
  Future<void> incrementFollowing() async {
    try {
      await _firestore.collection('users').doc(userId)
          .collection('profile').doc(userId).update({
        'following': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing following: $e');
    }
  }
}

Future<void> showCreatePostDialog(BuildContext context) async {
  String description = '';
  File? selectedImage;

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    selectedImage = File(pickedFile.path);
  }

  if (selectedImage != null) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Post'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: const InputDecoration(hintText: 'Enter '
                      'description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Upload'),
              onPressed: () async {
                Navigator.of(context).pop();
                await uploadPost(description, selectedImage!);
              },
            ),
          ],
        );
      },
    );
  } else {
    print('No image selected.');
  }
}

Future<void> uploadPost(String description, File imageFile) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    final inkgramService = InkgramService(userId: userId);

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_posts')
        .child(userId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      // Upload the file
      final uploadTask = await storageRef.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Add the post details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('inkgram')
          .add({
        'picture': downloadUrl,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'isLiked': false
      });

      // Increment the user's post count
      await inkgramService.incrementPosts();
    } catch (e) {
      print('Error uploading post: $e');
    }
  } else {
    print('User not signed in.');
  }
}
