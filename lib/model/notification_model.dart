import 'package:cloud_firestore/cloud_firestore.dart';
class NotificationModel {
  final String id;
  final String userId;
  final String postId;
  final String username;
  final String type; // e.g., 'like'
  final Timestamp timestamp;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.username,
    required this.type,
    required this.timestamp,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'],
      postId: data['postId'],
      username: data['username'],
      type: data['type'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'postId': postId,
      'username': username,
      'type': type,
      'timestamp': timestamp,
    };
  }
}
