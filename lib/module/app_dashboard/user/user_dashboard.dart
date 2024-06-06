import 'package:InklusiveDraw/module/app_dashboard/user/user_appbar.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_banner.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_categories.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_content.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_header.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_search.dart';
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // header
              UserHeader(),
              SizedBox(height: 16),

              // search bar
              UserSearch(),
              SizedBox(height: 16),

              // categories
              UserCategories(),

              // banners
              UserBanner(),
              SizedBox(height: 16),

              // content
              UserContent()
            ],
          ),
        ),
      ),
    );
  }
}


