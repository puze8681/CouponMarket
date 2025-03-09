import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/model/user_coupon.dart';
import 'package:uuid/uuid.dart';

class Coupon {
  final String id;
  final String storeId;
  final String storeName;
  final String title;
  final String description;
  final int stock;
  final int code;
  final DateTime postStartAt;
  final DateTime postEndAt;
  final DateTime useStartAt;
  final DateTime useEndAt;

  Coupon({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.title,
    required this.description,
    required this.stock,
    required this.code,
    required this.postStartAt,
    required this.postEndAt,
    required this.useStartAt,
    required this.useEndAt,
  });

  // From Firestore
  factory Coupon.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Coupon(
      id: doc.id,
      storeId: data['storeId'] ?? '',
      storeName: data['storeName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      stock: data['stock'] ?? 0,
      code: data['code'] ?? 0,
      postStartAt: (data['postStartAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      postEndAt: (data['postEndAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      useStartAt: (data['useStartAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      useEndAt: (data['useEndAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // From JSON
  factory Coupon.fromJson(Map<String, dynamic> json, {String? id}) {
    return Coupon(
      id: id ?? json['id'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      stock: json['stock'] ?? 0,
      code: json['code'] ?? 0,
      postStartAt: json['postStartAt'] != null
          ? (json['postStartAt'] is String
          ? DateTime.parse(json['postStartAt'])
          : (json['postStartAt'] as Timestamp).toDate())
          : DateTime.now(),
      postEndAt: json['postEndAt'] != null
          ? (json['postEndAt'] is String
          ? DateTime.parse(json['postEndAt'])
          : (json['postEndAt'] as Timestamp).toDate())
          : DateTime.now(),
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
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'title': title,
      'description': description,
      'stock': stock,
      'code': code,
      'postStartAt': Timestamp.fromDate(postStartAt),
      'postEndAt': Timestamp.fromDate(postEndAt),
      'useStartAt': Timestamp.fromDate(useStartAt),
      'useEndAt': Timestamp.fromDate(useEndAt),
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'storeName': storeName,
      'title': title,
      'description': description,
      'stock': stock,
      'code': code,
      'postStartAt': postStartAt.toIso8601String(),
      'postEndAt': postEndAt.toIso8601String(),
      'useStartAt': useStartAt.toIso8601String(),
      'useEndAt': useEndAt.toIso8601String(),
    };
  }

  // Copy with
  Coupon copyWith({
    String? id,
    String? storeId,
    String? storeName,
    String? title,
    String? description,
    int? stock,
    int? code,
    DateTime? postStartAt,
    DateTime? postEndAt,
    DateTime? useStartAt,
    DateTime? useEndAt,
  }) {
    return Coupon(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      title: title ?? this.title,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      code: code ?? this.code,
      postStartAt: postStartAt ?? this.postStartAt,
      postEndAt: postEndAt ?? this.postEndAt,
      useStartAt: useStartAt ?? this.useStartAt,
      useEndAt: useEndAt ?? this.useEndAt,
    );
  }

  // Create UserCoupon from this Coupon
  UserCoupon download(String userId) {
    return UserCoupon(
      id: const Uuid().v4(),
      couponId: id,
      storeId: storeId,
      storeName: storeName,
      userId: userId,
      title: title,
      description: description,
      useStartAt: useStartAt,
      useEndAt: useEndAt,
      createdAt: DateTime.now(),
    );
  }
}