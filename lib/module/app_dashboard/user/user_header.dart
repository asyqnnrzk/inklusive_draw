import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../source/text_theme.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  Future<Map<String, dynamic>> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      return userDoc.data()!;
    } else {
      throw Exception('User data not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicatorTheme();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data found');
        } else {
          var userData = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, ${userData['username']}',
                style: LightTextTheme.dashboardTxt,
              ),
              Text(
                'Your dashboard',
                style: LightTextTheme.dashboardHeadline,
              ),
            ],
          );
        }
      },
    );
  }
}
