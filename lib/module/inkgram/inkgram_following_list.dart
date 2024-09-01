import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../source/text_theme.dart';
import 'inkgram_profile.dart';

class InkgramFollowingList extends StatelessWidget {
  final String userId;

  const InkgramFollowingList({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> getFollowingUsers() async {
    final profileId = await _getProfileId(userId);
    if (profileId == null) {
      return [];
    }

    final followingDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc(profileId)
        .collection('following')
        .where('isDeleted', isEqualTo: false)
        .get();

    return followingDocs.docs
        .map((doc) => {
      'userId': doc.id,
      'userName': doc['userName'],
    })
        .toList();
  }

  Future<String?> _getProfileId(String userId) async {
    final profileDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .get();

    if (profileDocs.docs.isNotEmpty) {
      return profileDocs.docs.first.id;
    } else {
      return null;
    }
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
          'Following',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getFollowingUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No following users found',
                style: LightTextTheme.dashboardTxt,
              ));
          } else {
            final followingUsers = snapshot.data!;
            return ListView.builder(
              itemCount: followingUsers.length,
              itemBuilder: (context, index) {
                final user = followingUsers[index];
                return ListTile(
                  title: Text(
                    user['userName'] ?? 'Unknown User',
                    style: LightTextTheme.dashboardTxt,
                  ),
                  onTap: () {
                    // Navigate to the profile of the followed user
                    Get.to(() => InkgramProfile(userId: user['userId']));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
