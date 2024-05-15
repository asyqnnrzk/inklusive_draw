import 'package:InklusiveDraw/user_auth_and_profile/login.dart';
import 'package:InklusiveDraw/user_auth_and_profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const TextStyle appName = TextStyle(
  color: Colors.white,
  fontSize: 24.0,
  fontStyle: FontStyle.italic,
  fontFamily: 'MontserratBoth',
);

const TextStyle textName = TextStyle(
  color: Color(0xFF58B9A1),
  fontSize: 16.0,
  fontFamily: 'MontserratRegular',
);

class DrawerContent extends StatefulWidget {
  const DrawerContent({Key? key}) : super(key: key);

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _checkLoginAndNavigateToProfile() {
    if (_user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: _user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 150.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF58B9A1)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'InklusiveDraw',
                    style: appName
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text(
                'Profile',
              style: textName,
            ),
            onTap: () {
              // go to Profile page
              _checkLoginAndNavigateToProfile();
            },
          ),
          ListTile(
            title: const Text(
                'Notifications',
              style: textName,
            ),
            onTap: () {
              // go to Notifications page
            },
          ),
          ListTile(
            title: const Text(
                'Setting',
              style: textName,
            ),
            onTap: () {
              // go to Setting page
            },
          ),
          const Divider(
            height: 16.0,
            color: Color(0xFF58B9A1),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const FavTiles()
        ],
      ),
    );
  }
}

class FavTiles extends StatelessWidget {
  const FavTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
          'Favorites',
        style: textName,
      ),
      subtitle: ExpansionTile(
        title: const Text(
          'Item 1',
          style: textName,
        ),
        children: <Widget> [
          ListTile(
            title: const Text(
              'Subitem 1',
              style: textName,
            ),
            onTap: () {
              // go to Favorites page
            },
          ),
          ListTile(
            title: const Text(
              'Subitem 2',
              style: textName,
            ),
            onTap: () {
              // go to Favorites page
            },
          ),
        ],
      ),
    );
  }
}

