// import 'package:InklusiveDraw/module/mainpage/homepage.dart';
// import 'package:InklusiveDraw/module/user_auth_and_profile/login/login_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     home: ProfilePage(),
//   ));
// }
//
// const TextStyle profileName = TextStyle(
//   color: Colors.black54,
//   fontSize: 24.0,
//   fontFamily: 'MontserratBold',
// );
//
// const TextStyle profileUsername = TextStyle(
//   color: Colors.black54,
//   fontSize: 16.0,
//   fontFamily: 'MontserratRegular',
// );
//
// const TextStyle smallTxt = TextStyle(
//   color: Colors.black54,
//   fontSize: 10.0,
//   fontFamily: 'MontserratRegular',
// );
//
// const TextStyle descTxt = TextStyle(
//   color: Colors.black54,
//   fontSize: 16.0,
//   fontFamily: 'MontserratRegular',
// );
//
// const TextStyle alertTxt = TextStyle(
//   color: Color(0xFFEC8696),
//   fontSize: 16.0,
//   fontFamily: 'MontserratRegular',
// );
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? userData;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }
//
//   Future<void> _fetchUserData() async {
//     final userDoc = FirebaseFirestore.instance.collection('users')
//         .doc('userinfo');
//     final docSnapshot = await userDoc.get();
//     if (docSnapshot.exists) {
//       setState(() {
//         userData = docSnapshot.data();
//       });
//     }
//   }
//
//   void _logoutConfirmation(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Theme(
//             data: Theme.of(context).copyWith(
//               dialogBackgroundColor: Colors.white,
//             ),
//             child: AlertDialog(
//               title: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   fontFamily: 'MontserratBoth',
//                   fontSize: 24.0,
//                   color: Colors.black54
//                 ),
//               ),
//               content: const Text(
//                 'Are you sure you want to logout?',
//                 style: alertTxt,
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: Color(0xFF58B9A1),
//                       fontFamily: 'MontserratRegular'
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _logout(context);
//                   },
//                   child: const Text(
//                     'Logout',
//                     style: TextStyle(
//                       color: Color(0xFFEC8696),
//                       fontFamily: 'MontserratBold'
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         }
//     );
//   }
//
//   void _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     print('Logged out');
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//           (Route<dynamic> route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: const Color(0xFF58B9A1),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) =>
//             const HomePage()),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//
//             },
//             icon: const Icon(Icons.notifications_rounded),
//             tooltip: 'Notifications',
//             color: const Color(0xFF58B9A1),
//           ),
//           const SizedBox(width: 8.0),
//           IconButton(
//             onPressed: () {
//
//             },
//             icon: const Icon(Icons.share),
//             tooltip: 'Share',
//             color: const Color(0xFF58B9A1),
//           ),
//           const SizedBox(width: 8.0),
//           IconButton(
//             onPressed: () {
//               _logoutConfirmation(context);
//             },
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             color: const Color(0xFF58B9A1),
//           ),
//           const SizedBox(width: 8.0),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(4.0),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.black54,
//                         width: 1,
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.transparent,
//                       // for now put the default image
//                       child: Image.asset(
//                         'assets/images/default_profile.png',
//                         height: 75,
//                         width: 75,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // hardcode for now
//                         Text(
//                           userData?['name'],
//                           style: profileName,
//                         ),
//                         Text(
//                           userData?['username'],
//                           style: profileUsername,
//                         ),
//                         const SizedBox(height: 4.0),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 // copy the text
//                                 Clipboard.setData(const ClipboardData(text: '52137'));
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: const Text(
//                                       'Copied to clipboard',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     backgroundColor: const Color(0xFF58B9A1),
//                                     duration: const Duration(seconds: 2),
//                                     behavior: SnackBarBehavior.floating,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                 decoration: BoxDecoration(
//                                     color: Colors.transparent,
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                         color: Colors.black54
//                                     )
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       userData?['id'],
//                                       style: smallTxt,
//                                     ),
//                                     const SizedBox(width: 2),
//                                     const Icon(
//                                       Icons.copy,
//                                       size: 10,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 4.0),
//                             GestureDetector(
//                               onTap: () {
//                                 // go to edit profile page
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                 decoration: BoxDecoration(
//                                     color: const Color.fromRGBO(88, 185, 161, 0.5),
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                         color: const Color(0xFF58B9A1)
//                                     )
//                                 ),
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       'Edit profile',
//                                       style: TextStyle(
//                                         fontFamily: 'MontserratRegular',
//                                         fontSize: 10.0,
//                                         color: Colors.black54
//                                       ),
//                                     ),
//                                     SizedBox(width: 2),
//                                     Icon(
//                                       Icons.edit,
//                                       size: 10,
//                                       color: Colors.black54,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       decoration: const BoxDecoration(
//                         color: Color.fromRGBO(88, 185, 161, 0.5),
//                       ),
//                       child: const Column(
//                         children: [
//                           Text(
//                             '4'
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                               'posts'
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       decoration: const BoxDecoration(
//                         color: Color.fromRGBO(88, 185, 161, 0.5),
//                       ),
//                       child: const Column(
//                         children: [
//                           Text(
//                               '23'
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                               'followers'
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       decoration: const BoxDecoration(
//                         color: Color.fromRGBO(88, 185, 161, 0.5),
//                       ),
//                       child: const Column(
//                         children: [
//                           Text(
//                               '23'
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                               'following'
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8.0),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Hello. Let's draw!"),
//                     const SizedBox(height: 4.0),
//                     GestureDetector(
//                       onTap: () {
//                         print('Tapped');
//                       },
//                       child: const Text(
//                         'https://mycard.com',
//                         style: TextStyle(
//                             fontFamily: 'descTxt',
//                             color: Color(0xFF58B9A1),
//                             decoration: TextDecoration.underline
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               const ImagePosted(),
//               const SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       elevation: 0.0
//                     ),
//                     onPressed: () {
//                       // go to community page
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                           color: const Color(0xFF58B9A1),
//                         borderRadius: BorderRadius.circular(5.0)
//                       ),
//                       child: const Icon(
//                         Icons.group,
//                         size: 10,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 4.0),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0.0
//                     ),
//                     onPressed: () {
//                       // go to favorites page
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF58B9A1),
//                         borderRadius: BorderRadius.circular(5.0)
//                       ),
//                       child: Image.asset(
//                         'assets/icons/heart_icon.png',
//                         width: 10,
//                         height: 10,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 4.0),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0.0
//                     ),
//                     onPressed: () {
//                       // go to dashboard page
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                           color: const Color(0xFF58B9A1),
//                           borderRadius: BorderRadius.circular(5.0)
//                       ),
//                       child: const Icon(
//                         Icons.dashboard,
//                         size: 10,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ImagePosted extends StatefulWidget {
//   const ImagePosted({super.key});
//
//   @override
//   State<ImagePosted> createState() => _ImagePostedState();
// }
//
// class _ImagePostedState extends State<ImagePosted> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         height: 200,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.black54,
//             width: 1
//           )
//         ),
//         child: GridView.count(
//           crossAxisCount: 3,
//           children: List.generate(
//             4,
//                 (index) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/images/default_image.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
