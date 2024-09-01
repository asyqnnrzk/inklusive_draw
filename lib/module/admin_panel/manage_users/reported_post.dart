import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportedPost extends StatelessWidget {
  final String postId;
  final String userId;

  const ReportedPost({required this.postId, required this.userId, Key? key})
      : super(key: key);

  Future<Map<String, dynamic>?> _fetchPostData() async {
    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('inkgram')
          .doc(postId)
          .get();

      if (!postDoc.exists) {
        return null;
      }

      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;

      // Fetch the username and email from the user's document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String? username = userDoc['username'];
        String? email = userDoc['email'];
        postData['username'] = username;
        postData['email'] = email;
      }

      return postData;
    } catch (e) {
      print('Error fetching post data: $e');
      return null;
    }
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Reported Post Information',
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
          'Reported Post',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchPostData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicatorTheme());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Post not found.'));
            }

            Map<String, dynamic> postData = snapshot.data!;
            String? email = postData['email'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (postData.containsKey('picture'))
                    Image.network(postData['picture']),
                  const SizedBox(height: 16),
                  Text(
                    postData['description'] ?? 'No description available.',
                    style: LightTextTheme.dashboardTxt,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Posted by: ${postData['username'] ?? 'Unknown User'}',
                        style: LightTextTheme.dashboardTxt,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.email, color: primaryColor),
                        onPressed: email != null
                            ? () => _sendEmail(email)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
