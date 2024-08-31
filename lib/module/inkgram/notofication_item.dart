import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/notification_model.dart';
import '../../source/colors.dart';
import '../../source/text_theme.dart';
import 'package:get/get.dart';
import 'inkgram_profile.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String notificationText;
    IconData notificationIcon;

    switch (notification.type) {
      case 'like':
        notificationText = 'liked your post';
        notificationIcon = Icons.favorite;
        break;
      default:
        notificationText = 'performed an action';
        notificationIcon = Icons.notifications;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: secondaryColor,
        child: Icon(
          notificationIcon,
          color: Colors.white,
        ),
      ),
      title: Text(
        'User ${notification.fromUserId} $notificationText',
        style: LightTextTheme.dashboardTxt,
      ),
      subtitle: Text(
        DateFormat.yMMMd().add_jm().format(notification.timestamp.toDate()),
        style: LightTextTheme.dashboardTxt,
      ),
      onTap: () {
        if (notification.type == 'like') {
          Get.to(() => InkgramProfile(userId: notification.fromUserId));
        }
      },
    );
  }
}
