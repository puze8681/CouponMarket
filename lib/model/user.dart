import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String phone;
  final bool gender;
  final String address;
  final DateTime birth;
  final List<String> savedStoreIds;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.gender,
    required this.address,
    required this.birth,
    required this.savedStoreIds,
    required this.createdAt,
  });

  // From Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? false,
      address: data['address'] ?? '',
      birth: (data['birth'] as Timestamp?)?.toDate() ?? DateTime.now(),
      savedStoreIds: List<String>.from(data['savedStoreIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // From JSON
  factory User.fromJson(Map<String, dynamic> json, {String? id}) {
    return User(
      id: id ?? json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? false,
      address: json['address'] ?? '',
      birth: json['birth'] != null
          ? (json['birth'] is String
          ? DateTime.parse(json['birth'])
          : (json['birth'] as Timestamp).toDate())
          : DateTime.now(),
      savedStoreIds: List<String>.from(json['savedStoreIds'] ?? []),
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
      'name': name,
      'phone': phone,
      'gender': gender,
      'address': address,
      'birth': Timestamp.fromDate(birth),
      'savedStoreIds': savedStoreIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'gender': gender,
      'address': address,
      'birth': birth.toIso8601String(),
      'savedStoreIds': savedStoreIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Copy with
  User copyWith({
    String? id,
    String? name,
    String? phone,
    bool? gender,
    String? address,
    DateTime? birth,
    List<String>? savedStoreIds,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      birth: birth ?? this.birth,
      savedStoreIds: savedStoreIds ?? this.savedStoreIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}