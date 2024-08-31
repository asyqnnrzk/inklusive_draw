import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../model/notification_model.dart';
import '../../service/inkgram_service.dart';
import '../../source/colors.dart';
import '../../source/text_theme.dart';
import 'inkgram_homepage.dart';
import 'inkgram_profile.dart';
import 'inkgram_search.dart';
import 'notofication_item.dart';

class InkgramNotifications extends StatefulWidget {
  const InkgramNotifications({Key? key}) : super(key: key);

  @override
  State<InkgramNotifications> createState() => _InkgramNotificationsState();
}

class _InkgramNotificationsState extends State<InkgramNotifications> {
  int _selectedIndex = 3;
  final NotificationService _notificationService = NotificationService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _onItemTapped(int index) {
    if (index == 0) {
      Get.to(() => const InkgramHomepage());
    } else if (index == 1) {
      Get.to(() => const InkgramSearch());
    } else if (index == 2) {
      showCreatePostDialog(context);
    } else if (index == 4) {
      Get.to(() => InkgramProfile(userId: FirebaseAuth.instance
          .currentUser!.uid));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Notifications',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationService.getUserNotifications(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading notifications',
                style: LightTextTheme.dashboardTxt,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: LightTextTheme.dashboardTxt,
              ),
            );
          } else {
            final notifications = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationItem(notification: notification);
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
