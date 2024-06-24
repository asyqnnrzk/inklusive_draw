import 'package:InklusiveDraw/module/user_auth_and_profile/register/'
    'register_footer_widget.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/register/'
    'register_header_widget.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/register/'
    'register_form_widget.dart';
import 'package:flutter/material.dart';
import '../../../source/colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RegisterHeaderWidget(),
                SizedBox(height: 16),
                RegisterFormWidget(),
                RegisterFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
