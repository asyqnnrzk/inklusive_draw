import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../model/notification_model.dart';
import '../../service/inkgram_service.dart';
import '../../source/colors.dart';
import '../../source/text_theme.dart';
import 'inkgram_homepage.dart';
import 'inkgram_profile.dart';
import 'inkgram_search.dart';

class InkgramNotifications extends StatefulWidget {
  const InkgramNotifications({Key? key}) : super(key: key);

  @override
  State<InkgramNotifications> createState() => _InkgramNotificationsState();
}

class _InkgramNotificationsState extends State<InkgramNotifications> {
  int _selectedIndex = 3;
  final NotificationService _notificationService = NotificationService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String _formatTimestamp(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = dateFormat.format(dateTime);
    final formattedTime = timeFormat.format(dateTime);
    return 'on $formattedDate at $formattedTime';
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Get.to(() => const InkgramHomepage());
    } else if (index == 1) {
      Get.to(() => const InkgramSearch());
    } else if (index == 2) {
      showCreatePostDialog(context);
    } else if (index == 4) {
      Get.to(() => InkgramProfile(userId: FirebaseAuth.instance.currentUser!
          .uid));
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
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'This account does not exist anymore',
                style: LightTextTheme.dashboardTxt,
              ));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                  'No new notifications',
                  style: LightTextTheme.dashboardTxt,
                ));
          }

          final notifications = snapshot.data!;
          for (var notification in notifications) {
            print('Notification: ${notification.toMap()}');
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text('${notification.username} liked your post'),
                titleTextStyle: LightTextTheme.dashboardTxtBold,
                subtitle: Text(_formatTimestamp(notification.timestamp
                    .toDate())),
                subtitleTextStyle: LightTextTheme.dashboardTxt,
                onTap: () {
                  print('Navigating to profile with userId: '
                      '${notification.userId}');
                  Get.to(() => InkgramProfile(userId: notification.userId));
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
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
