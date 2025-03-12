import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/model/coupon.dart';

class UserCoupon {
  final String id;
  final String couponId;
  final String storeId;
  final String storeName;
  final String title;
  final String description;
  final String image;
  final DateTime useStartAt;
  final DateTime useEndAt;
  final DateTime createdAt;
  final DateTime? usedAt;

  UserCoupon({
    required this.id,
    required this.couponId,
    required this.storeId,
    required this.storeName,
    required this.title,
    required this.description,
    required this.image,
    required this.useStartAt,
    required this.useEndAt,
    required this.createdAt,
    required this.usedAt,
  });

  // From Firestore
  factory UserCoupon.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserCoupon(
      id: data['id'] ?? '',
      couponId: data['couponId'] ?? '',
      storeId: data['storeId'] ?? '',
      storeName: data['storeName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      useStartAt: (data['useStartAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      useEndAt: (data['useEndAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      usedAt: (data['usedAt'] as Timestamp?)?.toDate(),
    );
  }

  // From JSON
  factory UserCoupon.fromJson(Map<String, dynamic> json) {
    return UserCoupon(
      id: json['id'] ?? '',
      couponId: json['couponId'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
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
      usedAt: json['usedAt'] != null
          ? (json['usedAt'] is String
          ? DateTime.parse(json['usedAt'])
          : (json['usedAt'] as Timestamp).toDate())
          : null,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'couponId': couponId,
      'storeId': storeId,
      'storeName': storeName,
      'title': title,
      'description': description,
      'image': image,
      'useStartAt': Timestamp.fromDate(useStartAt),
      'useEndAt': Timestamp.fromDate(useEndAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'usedAt': usedAt != null ? Timestamp.fromDate(createdAt) : null,
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couponId': couponId,
      'storeId': storeId,
      'storeName': storeName,
      'title': title,
      'description': description,
      'image': image,
      'useStartAt': useStartAt.toIso8601String(),
      'useEndAt': useEndAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
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
    String? image,
    DateTime? useStartAt,
    DateTime? useEndAt,
    DateTime? createdAt,
    DateTime? usedAt,
  }) {
    return UserCoupon(
      id: id,
      couponId: couponId ?? this.couponId,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      useStartAt: useStartAt ?? this.useStartAt,
      useEndAt: useEndAt ?? this.useEndAt,
      createdAt: createdAt ?? this.createdAt,
      usedAt: usedAt ?? this.usedAt,
    );
  }

  UserCoupon use() {
    return UserCoupon(
      id: id,
      couponId: couponId,
      storeId: storeId,
      storeName: storeName,
      title: title,
      description: description,
      image: image,
      useStartAt: useStartAt,
      useEndAt: useEndAt,
      createdAt: createdAt,
      usedAt: DateTime.now(),
    );
  }

  Coupon toCoupon() {
    return Coupon(
      id: couponId,
      storeId: storeId,
      storeName: storeName,
      title: title,
      description: description,
      image: image,
      stock: 0, // 사용자가 이미 다운로드했으므로 의미 없음
      code: '', // 사용자가 이미 다운로드했으므로 비공개
      category: [], // UserCoupon에는 카테고리 정보가 없을 수 있음
      district: 0, // UserCoupon에는 지역 정보가 없을 수 있음
      city: 0, // UserCoupon에는 지역 정보가 없을 수 있음
      postStartAt: DateTime.now(), // 의미 없음
      postEndAt: DateTime.now(), // 의미 없음
      useStartAt: useStartAt,
      useEndAt: useEndAt,
    );
  }
}