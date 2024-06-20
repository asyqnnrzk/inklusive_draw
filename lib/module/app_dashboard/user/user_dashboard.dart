import 'package:InklusiveDraw/module/app_dashboard/user/user_appbar.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_banner.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_content.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_header.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const UserDashboardAppbar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // header
              const UserHeader(),
              const SizedBox(height: 16),

              // banners
              UserBanner(),
              const SizedBox(height: 16),

              // content
              const UserContent()
              // hardcode, have to be changed once drawing is successful implemented
            ],
          ),
        ),
      ),
    );
  }
}


