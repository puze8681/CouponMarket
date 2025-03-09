import 'package:cloud_firestore/cloud_firestore.dart';

class UserCoupon {
  final String id;
  final String couponId;
  final String storeId;
  final String storeName;
  final String userId;
  final String title;
  final String description;
  final DateTime useStartAt;
  final DateTime useEndAt;
  final DateTime createdAt;

  UserCoupon({
    required this.id,
    required this.couponId,
    required this.storeId,
    required this.storeName,
    required this.userId,
    required this.title,
    required this.description,
    required this.useStartAt,
    required this.useEndAt,
    required this.createdAt,
  });

  // From Firestore
  factory UserCoupon.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserCoupon(
      id: data['id'] ?? '',
      couponId: data['couponId'] ?? '',
      storeId: data['storeId'] ?? '',
      storeName: data['storeName'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      useStartAt: (data['useStartAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      useEndAt: (data['useEndAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // From JSON
  factory UserCoupon.fromJson(Map<String, dynamic> json) {
    return UserCoupon(
      id: json['id'] ?? '',
      couponId: json['couponId'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      useStartAt: json['useStartAt'] != null
          ? (json['useStartAt'] is String
          ? DateTime.parse(json['useStartAt'])
          : (json['useStartAt'] as Timestamp).toDate())
          : DateTime.now(),
      useEndAt: json['useEndAt'] != null
          ? (json['useEndAt'] is String
          ? DateTime.parse(json['useEndAt'])
          : (json['useEndAt'] as Timestamp).toDate())
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : (json['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'couponId': couponId,
      'storeId': storeId,
      'storeName': storeName,
      'userId': userId,
      'title': title,
      'description': description,
      'useStartAt': Timestamp.fromDate(useStartAt),
      'useEndAt': Timestamp.fromDate(useEndAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couponId': couponId,
      'storeId': storeId,
      'storeName': storeName,
      'userId': userId,
      'title': title,
      'description': description,
      'useStartAt': useStartAt.toIso8601String(),
      'useEndAt': useEndAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Copy with
  UserCoupon copyWith({
    String? couponId,
    String? storeId,
    String? storeName,
    String? userId,
    String? title,
    String? description,
    DateTime? useStartAt,
    DateTime? useEndAt,
    DateTime? createdAt,
  }) {
    return UserCoupon(
      id: id,
      couponId: couponId ?? this.couponId,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      useStartAt: useStartAt ?? this.useStartAt,
      useEndAt: useEndAt ?? this.useEndAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}