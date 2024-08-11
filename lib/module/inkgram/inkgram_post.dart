import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> showCreatePostDialog(BuildContext context) async {
  String description = '';
  File? selectedImage;

  // Pick an image before showing the dialog
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
  // Get current user ID
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    // Create a reference to the user's folder in Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_posts')
        .child(userId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file
    final uploadTask = await storageRef.putFile(imageFile);

    // Get the download URL
    final downloadUrl = await storageRef.getDownloadURL();

    // Save the post details in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('inkgram')
        .add({
      'picture': downloadUrl,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } else {
    print('User not signed in.');
  }
}
