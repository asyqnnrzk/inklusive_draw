import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type; // 'like' or 'follow'
  final String fromUserId;
  final String? postId;
  final Timestamp timestamp;

  NotificationModel({
    required this.id,
    required this.type,
    required this.fromUserId,
    this.postId,
    required this.timestamp,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      type: data['type'] as String,
      fromUserId: data['fromUserId'] as String,
      postId: data['postId'] as String?,
      timestamp: data['timestamp'] as Timestamp,
    );
  }
}
