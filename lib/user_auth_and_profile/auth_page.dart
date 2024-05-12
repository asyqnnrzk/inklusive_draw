import 'package:InklusiveDraw/main.dart';
import 'package:InklusiveDraw/user_auth_and_profile/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user successfully logged in
          if (snapshot.hasData) {
            // go to Profile page
            // but make it to homepage for now
            return InklusiveDraw();
          }
          // user not logged in
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
