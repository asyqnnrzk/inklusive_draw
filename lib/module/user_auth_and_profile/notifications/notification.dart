import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  Map payload = {};

  @override
  Widget build(BuildContext context) {

    final data = ModalRoute.of(context)!.settings.arguments;

    // for background and terminated state
    if(data is RemoteMessage) {
      payload = data.data;
    }

    // for foreground state
    if(data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tes'),
      ),
      body: Center(
        child: Text(payload.toString()),
      ),
    );
  }
}
