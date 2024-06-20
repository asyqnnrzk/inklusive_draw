import 'package:firebase_auth/firebase_auth.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/colors.dart';
import '../../../source/image_strings.dart';
import '../../service/firestore_service.dart';
import 'store_image.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String _imageUrl = userDefault;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    if (_currentUser != null) {
      String userId = _currentUser!.uid;
      try {
        Map<String, dynamic> userData = await _firestoreService.getUserData(userId);
        Map<String, dynamic> profileData = await _firestoreService.getUserProfile(userId);
        setState(() {
          _imageUrl = profileData['avatar'] ?? userDefault;
          _nameController.text = userData['name'] ?? '';
          _usernameController.text = userData['username'] ?? '';
          _bioController.text = profileData['bio'] ?? '';
        });
      } catch (e) {
        print('Error fetching profile data: $e');
      }
    }
  }

  Future<void> _updateProfileImage() async {
    StoreImage storeImage = StoreImage();
    String? imageUrl = await storeImage.uploadImageAndGetUrl();
    if (imageUrl != null) {
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_currentUser != null) {
        String userId = _currentUser!.uid;

        Map<String, dynamic> userData = {
          'name': _nameController.text,
          'username': _usernameController.text,
        };

        Map<String, dynamic> profileData = {
          'avatar': _imageUrl,
          'bio': _bioController.text,
        };

        await _firestoreService.updateUserData(userId, userData);
        await _firestoreService.updateUserProfile(userId, profileData);
        Get.back();
      } else {
        print('User is not authenticated');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Edit profile',
          style: LightTextTheme.profileHeadline,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        _imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _updateProfileImage,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.camera_solid,
                          size: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text('Name'),
                        hintText: 'Name',
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        label: Text('Username'),
                        hintText: 'Username',
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        label: Text('Bio'),
                        hintText: 'Bio',
                        prefixIcon: Icon(
                          Icons.info,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'MontserratRegular',
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(0.1),
                        elevation: 0,
                        foregroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'MontserratBold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
