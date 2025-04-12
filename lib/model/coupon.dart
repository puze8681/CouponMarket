import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String title;
  final String description;
  final String code;
  final int existCount;
  final int usedCount;

  Coupon({
    required this.title,
    required this.description,
    required this.code,
    required this.existCount,
    required this.usedCount,
  });

  // From Firestore
  factory Coupon.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Coupon(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      code: data['code'] ?? '',
      existCount: data['existCount'] ?? 0,
      usedCount: data['usedCount'] ?? 0,
    );
  }

  // From JSON
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      existCount: json['existCount'] ?? 0,
      usedCount: json['usedCount'] ?? 0,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'code': code,
      'existCount': existCount,
      'usedCount': usedCount,
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'code': code,
      'existCount': existCount,
      'usedCount': usedCount,
    };
  }

  // Copy with
  Coupon copyWith({
    String? title,
    String? description,
    String? code,
    int? existCount,
    int? usedCount,
  }) {
    return Coupon(
      title: title ?? this.title,
      description: description ?? this.description,
      code: code ?? this.code,
      existCount: existCount ?? this.existCount,
      usedCount: usedCount ?? this.usedCount,
    );
  }

  // 사용 가능한 쿠폰 수
  int get availableCount {
    return existCount - usedCount;
  }
}