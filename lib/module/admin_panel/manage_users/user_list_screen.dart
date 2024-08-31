import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  Future<void> softDeleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isDeleted': true,
      'deletedAt': Timestamp.now(),
    });
  }

  void sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': '',
        'body': '',
      }),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<Map<String, dynamic>> _fetchProfileData(String userId) async {
    final profileCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile');

    final profileSnapshot = await profileCollection.get();
    if (profileSnapshot.docs.isNotEmpty) {
      final profileDoc = profileSnapshot.docs.first;
      return profileDoc.data();
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'User List',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('isDeleted', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching users',
                style: LightTextTheme.dashboardTxt,
              ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No users found',
                style: LightTextTheme.dashboardTxt,
              ));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final username = user['username'] ?? 'No Username';
              final email = user['email'] ?? 'No Email';

              return FutureBuilder<Map<String, dynamic>>(
                future: _fetchProfileData(userId),
                builder: (context, profileSnapshot) {
                  if (profileSnapshot.connectionState == ConnectionState
                      .waiting) {
                    return ListTile(
                      leading: const CircularProgressIndicator(),
                      title: Text(username),
                      subtitle: Text(email),
                    );
                  }

                  if (profileSnapshot.hasError || !profileSnapshot.hasData) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(username),
                      subtitle: Text(email),
                      trailing: const SizedBox.shrink(),
                    );
                  }

                  final profileData = profileSnapshot.data!;
                  final bio = profileData['bio'] ?? 'No Bio';
                  final avatarUrl = profileData['avatar'] ?? '';

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl.isEmpty ? const Icon(Icons.person) :
                          null,
                        ),
                        title: Text('Username: $username'),
                        titleTextStyle: LightTextTheme.dashboardTxt,
                        subtitle: Text('Bio: $bio\n$email'),
                        subtitleTextStyle: LightTextTheme.dashboardTxt,
                        isThreeLine: true,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.email),
                              color: primaryColor,
                              onPressed: () => sendEmail(email),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                final confirm = await Get.defaultDialog<bool>(
                                  title: 'Delete User',
                                  titleStyle: LightTextTheme.deleteBtn,
                                  middleText: 'Are you sure you want to delete '
                                      '$username?',
                                  middleTextStyle: LightTextTheme.reportDetails,
                                  confirm: ElevatedButton(
                                    onPressed: () {
                                      Get.back(result: true);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: LightTextTheme.deleteBtn,
                                    ),
                                  ),
                                  cancel: TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: Text(
                                      'Cancel',
                                      style: LightTextTheme.cancelBtn,
                                    ),
                                  ),
                                );

                                if (confirm == true) {
                                  await softDeleteUser(userId);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
