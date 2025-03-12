import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/constant/category_constants.dart';
import 'package:coupon_market/constant/korean_constants.dart';
import 'package:coupon_market/model/user_coupon.dart';
import 'package:uuid/uuid.dart';

class Coupon {
  final String id;
  final String storeId;
  final String storeName;
  final String title;
  final String description;
  final String image;
  final int stock;
  final String code;
  final List<int> category;
  final int district;
  final int city;
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
    required this.image,
    required this.stock,
    required this.code,
    required this.category,
    required this.district,
    required this.city,
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
      image: data['image'] ?? '',
      stock: data['stock'] ?? 0,
      code: data['code'] ?? '0000',
      category: List<int>.from(data['category'] ?? []),
      district: data['district'] ?? 0,
      city: data['city'] ?? 0,
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
      image: json['image'] ?? '',
      stock: json['stock'] ?? 0,
      code: json['code'] ?? '0000',
      category: json['category'] != null
          ? List<int>.from(json['category'])
          : [],
      district: json['district'] ?? 0,
      city: json['city'] ?? 0,
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
      'image': image,
      'stock': stock,
      'code': code,
      'category': category,
      'district': district,
      'city': city,
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
      'image': image,
      'stock': stock,
      'code': code,
      'category': category,
      'district': district,
      'city': city,
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
    String? image,
    int? stock,
    String? code,
    List<int>? category,
    int? district,
    int? city,
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
      image: image ?? this.image,
      stock: stock ?? this.stock,
      code: code ?? this.code,
      category: category ?? this.category,
      district: district ?? this.district,
      city: city ?? this.city,
      postStartAt: postStartAt ?? this.postStartAt,
      postEndAt: postEndAt ?? this.postEndAt,
      useStartAt: useStartAt ?? this.useStartAt,
      useEndAt: useEndAt ?? this.useEndAt,
    );
  }

  // Create UserCoupon from this Coupon
  UserCoupon get download {
    return UserCoupon(
      id: const Uuid().v4(),
      couponId: id,
      storeId: storeId,
      storeName: storeName,
      title: title,
      description: description,
      image: image,
      useStartAt: useStartAt,
      useEndAt: useEndAt,
      createdAt: DateTime.now(),
      usedAt: null,
    );
  }

  String get tCity {
    return KoreanCityConstants.cityNameMap[city] ?? '알 수 없음';
  }

  String get tDistrict {
    return KoreanDistrictConstants.districtNameMap[district] ?? '알 수 없음';
  }

  List<String> get tCategoryList {
    return FoodCategoryConstants.getCategoryNameList(category);
  }

  String get tCategory {
    return tCategoryList.join(", ");
  }

  List<String> get tCategoryGroup {
    return FoodCategoryConstants.getCategoryNameList(category);
  }

  String get tCategoryGroupList {
    return tCategoryGroup.join(", ");
  }
}