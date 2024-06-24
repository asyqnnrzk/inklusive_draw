import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StoreImage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> uploadImageAndGetUrl() async {
    try {
      // Pick an image from gallery
      final pickedFile = await _imagePicker.pickImage(source: ImageSource
          .gallery);
      if (pickedFile == null) {
        return null;
      }

      // Create a reference to the Firebase Storage location
      Reference reference = _storage.ref().child('images/${DateTime.now()
          .millisecondsSinceEpoch}');

      // Upload the image file to Firebase Storage
      await reference.putFile(File(pickedFile.path));

      // Get the download URL for the uploaded image
      String imageUrl = await reference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
