import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.notifications_rounded),
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
