import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_appbar.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_banner.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_content.dart';
import 'package:InklusiveDraw/module/app_dashboard/user/user_header.dart';
import '../../drawing_practice/gallery/recent_drawings.dart';

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
              FutureBuilder<RecentDrawings>(
                future: RecentDrawings.fetchRecentDrawings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child:
                    CircularProgressIndicatorTheme());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.recentDrawings
                      .isEmpty) {
                    return Center(child: Text(
                      'No recent drawings available',
                      style: LightTextTheme.dashboardTxtBold,
                    ));
                  } else {
                    return UserContent(recentDrawings: snapshot.data!
                        .recentDrawings);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
