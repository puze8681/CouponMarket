import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationData {
  final String text;
  final bool isRead;
  final DateTime createdAt;

  NotificationData({
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationData.create(String text) {
    return NotificationData(
      text: text,
      isRead: false,
      createdAt: DateTime.now(),
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      text: json["text"],
      isRead: json["isRead"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "isRead": isRead,
      "createdAt": createdAt,
    };
  }

  NotificationData setRead() {
    return NotificationData(
      text: text,
      isRead: true,
      createdAt: createdAt,
    );
  }

  int get id {
    return createdAt.millisecond;
  }
}