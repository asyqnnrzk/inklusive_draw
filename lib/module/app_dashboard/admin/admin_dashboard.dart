import 'package:InklusiveDraw/module/app_dashboard/admin/admin_appbar.dart';
import 'package:InklusiveDraw/module/app_dashboard/admin/admin_banner.dart';
import 'package:InklusiveDraw/module/app_dashboard/admin/admin_content.dart';
import 'package:InklusiveDraw/module/app_dashboard/admin/admin_header.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import '../../drawing_practice/gallery/recent_drawings.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminDashboardAppbar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              const AdminHeader(),
              const SizedBox(height: 16),

              // banners
              AdminBanner(),
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
                    return AdminContent();
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
