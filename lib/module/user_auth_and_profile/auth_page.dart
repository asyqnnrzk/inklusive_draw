// import 'package:InklusiveDraw/module/user_auth_and_profile/login/login_screen.dart';
// import 'package:InklusiveDraw/module/user_auth_and_profile/profile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData) {
//             User? user = snapshot.data;
//             if (user != null) {
//               return ProfilePage();
//             } else {
//               return LoginPage();
//             }
//           } else {
//             return LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }
