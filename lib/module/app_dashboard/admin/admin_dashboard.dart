import 'package:InklusiveDraw/module/app_dashboard/admin/admin_appbar.dart';
import 'package:InklusiveDraw/module/app_dashboard/admin/admin_banner.dart';
import 'package:InklusiveDraw/module/app_dashboard/admin/admin_content.dart';
import 'package:InklusiveDraw/module/app_dashboard/admin/admin_header.dart';
import 'package:flutter/material.dart';

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
              AdminContent()
            ],
          ),
        ),
      ),
    );
  }
}
