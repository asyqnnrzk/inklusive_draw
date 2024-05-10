import 'package:flutter/material.dart';

const TextStyle appName = TextStyle(
  color: Color(0xFFEC8696),
  fontSize: 24.0,
  fontStyle: FontStyle.italic,
  fontFamily: 'MontserratBoth',
);

const TextStyle textName = TextStyle(
  color: Colors.black54,
  fontSize: 16.0,
  fontFamily: 'MontserratRegular',
);

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: <Widget> [
          Text(''),
        ],
      ),
    );
  }
}
