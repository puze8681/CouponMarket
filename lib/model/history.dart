import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String storeId;
  final String storeName;
  final String couponTitle;
  final String couponDescription;
  final int? rating;
  final DateTime createdAt;

  History({
    required this.storeId,
    required this.storeName,
    required this.couponTitle,
    required this.couponDescription,
    this.rating,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // From Firestore
  factory History.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return History(
      storeId: data['storeId'] ?? '',
      storeName: data['storeName'] ?? '',
      couponTitle: data['couponTitle'] ?? '',
      couponDescription: data['couponDescription'] ?? '',
      rating: data['rating'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // From JSON
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      couponTitle: json['couponTitle'] ?? '',
      couponDescription: json['couponDescription'] ?? '',
      rating: json['rating'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'couponTitle': couponTitle,
      'couponDescription': couponDescription,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'couponTitle': couponTitle,
      'couponDescription': couponDescription,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Copy with
  History copyWith({
    String? storeId,
    String? storeName,
    String? couponTitle,
    String? couponDescription,
    int? rating,
    DateTime? createdAt,
  }) {
    return History(
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      couponTitle: couponTitle ?? this.couponTitle,
      couponDescription: couponDescription ?? this.couponDescription,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // 히스토리에 평점 추가
  History addRating(int rating) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
    return copyWith(rating: rating);
  }
}