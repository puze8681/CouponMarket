import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/constant/category_constants.dart';
import 'package:coupon_market/constant/korean_constants.dart';

class Store {
  final String id;
  final String name;
  final String description;
  final String image;
  final String phone;
  final String address;
  final String wifi;
  final String toilet;
  final List<String> keyword;
  final List<int> category;
  final int district;
  final int city;
  final int couponCount;
  final int userCount;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.phone,
    required this.address,
    required this.wifi,
    required this.toilet,
    required this.keyword,
    required this.category,
    required this.district,
    required this.city,
    required this.couponCount,
    required this.userCount,
  });

  // From Firestore
  factory Store.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Store(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      wifi: data['wifi'] ?? '',
      toilet: data['toilet'] ?? '',
      keyword: List<String>.from(data['keyword'] ?? []),
      category: List<int>.from(data['category'] ?? []),
      district: data['district'] ?? 0,
      city: data['city'] ?? 0,
      couponCount: data['couponCount'] ?? 0,
      userCount: data['userCount'] ?? 0,
    );
  }

  // From JSON
  factory Store.fromJson(Map<String, dynamic> json, {String? id}) {
    return Store(
      id: id ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      wifi: json['wifi'] ?? '',
      toilet: json['toilet'] ?? '',
      keyword: json['keyword'] != null
          ? List<String>.from(json['keyword'])
          : [],
      category: json['category'] != null
          ? List<int>.from(json['category'])
          : [],
      district: json['district'] ?? 0,
      city: json['city'] ?? 0,
      couponCount: json['couponCount'] ?? 0,
      userCount: json['userCount'] ?? 0,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'phone': phone,
      'address': address,
      'wifi': wifi,
      'toilet': toilet,
      'keyword': keyword,
      'category': category,
      'district': district,
      'city': city,
      'couponCount': couponCount,
      'userCount': userCount,
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'phone': phone,
      'address': address,
      'wifi': wifi,
      'toilet': toilet,
      'keyword': keyword,
      'category': category,
      'district': district,
      'city': city,
      'couponCount': couponCount,
      'userCount': userCount,
    };
  }

  // Copy with
  Store copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? phone,
    String? address,
    String? wifi,
    String? toilet,
    List<String>? keyword,
    List<int>? category,
    int? district,
    int? city,
    int? couponCount,
    int? userCount,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      wifi: wifi ?? this.wifi,
      toilet: toilet ?? this.toilet,
      keyword: keyword ?? this.keyword,
      category: category ?? this.category,
      district: district ?? this.district,
      city: city ?? this.city,
      couponCount: couponCount ?? this.couponCount,
      userCount: userCount ?? this.userCount,
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