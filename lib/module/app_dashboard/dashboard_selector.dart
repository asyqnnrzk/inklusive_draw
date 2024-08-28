import 'package:InklusiveDraw/module/app_dashboard/user/user_dashboard.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin/admin_dashboard.dart';

class DashboardSelector extends StatelessWidget {
  const DashboardSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicatorTheme()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.data == 'admin') {
          return const AdminDashboard();
        } else if (snapshot.data == 'user') {
          return const UserDashboard();
        } else {
          // Handle the case where no role is determined
          return Scaffold(
            body: Center(
              child: Text(
                'Access Denied or Role Not Found',
                style: LightTextTheme.dashboardTxtBold,
              )
            ),
          );
        }
      },
    );
  }

  Future<String?> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        print('Checking admin collection for UID: ${user.uid}');

        // Check if user exists in the 'admins' collection
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('admins').doc(user.uid).get();

        if (adminDoc.exists) {
          print('Admin found for UID: ${user.uid}');
          return 'admin';
        }

        print('Checking users collection for UID: ${user.uid}');

        // If not found in 'admins', check the 'users' collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          print('User found for UID: ${user.uid}');
          return 'user';
        }

        print('No user or admin found for UID: ${user.uid}');
      } catch (e) {
        print('Error getting user role: $e');
      }
    } else {
      print('No user is currently logged in.');
    }

    return null;
  }

}
