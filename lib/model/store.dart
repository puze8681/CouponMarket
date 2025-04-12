import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/constant/category_constants.dart';
import 'package:coupon_market/constant/korean_constants.dart';
import 'package:coupon_market/model/history.dart';

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
  final int couponExistCount; // 다운(사용) 가능한 쿠폰 개수
  final int couponUsedCount; // 사용된 쿠폰 개수
  final int ratingTotal; // 별점
  final int ratingCount; // 리뷰 개수
  final String couponTitle; // 쿠폰 제목
  final String couponDescription; // 쿠폰 설명
  final String couponCode; // 추가된 쿠폰 코드

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
    required this.couponExistCount,
    required this.couponUsedCount,
    required this.ratingTotal,
    required this.ratingCount,
    this.couponTitle = '',
    this.couponDescription = '',
    this.couponCode = '000000', // 기본값은 빈 문자열
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
      couponExistCount: data['couponExistCount'] ?? 0,
      couponUsedCount: data['couponUsedCount'] ?? 0,
      ratingTotal: data['ratingTotal'] ?? 0,
      ratingCount: data['ratingCount'] ?? 0,
      couponTitle: data['couponTitle'] ?? '',
      couponDescription: data['couponDescription'] ?? '',
      couponCode: data['couponCode'] ?? '', // Firestore에서 가져오기
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
      couponExistCount: json['couponExistCount'] ?? 0,
      couponUsedCount: json['couponUsedCount'] ?? 0,
      ratingTotal: json['ratingTotal'] ?? 0,
      ratingCount: json['ratingCount'] ?? 0,
      couponTitle: json['couponTitle'] ?? '',
      couponDescription: json['couponDescription'] ?? '',
      couponCode: json['couponCode'] ?? '', // JSON에서 가져오기
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
      'couponExistCount': couponExistCount,
      'couponUsedCount': couponUsedCount,
      'ratingTotal': ratingTotal,
      'ratingCount': ratingCount,
      'couponTitle': couponTitle,
      'couponDescription': couponDescription,
      'couponCode': couponCode, // Firestore에 저장하기
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
      'couponExistCount': couponExistCount,
      'couponUsedCount': couponUsedCount,
      'ratingTotal': ratingTotal,
      'ratingCount': ratingCount,
      'couponTitle': couponTitle,
      'couponDescription': couponDescription,
      'couponCode': couponCode, // JSON에 저장하기
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
    int? couponExistCount,
    int? couponUsedCount,
    int? ratingTotal,
    int? ratingCount,
    String? couponTitle,
    String? couponDescription,
    String? couponCode, // copyWith에 추가
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
      couponExistCount: couponExistCount ?? this.couponExistCount,
      couponUsedCount: couponUsedCount ?? this.couponUsedCount,
      ratingTotal: ratingTotal ?? this.ratingTotal,
      ratingCount: ratingCount ?? this.ratingCount,
      couponTitle: couponTitle ?? this.couponTitle,
      couponDescription: couponDescription ?? this.couponDescription,
      couponCode: couponCode ?? this.couponCode, // 기존 값 유지
    );
  }

  // 나머지 함수들은 변경하지 않음
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

  // 평점 계산 (1.0 ~ 5.0)
  double get rating {
    if (ratingCount == 0) return 0.0;
    return ratingTotal / ratingCount;
  }

  // 평점을 소수점 한 자리로 표시 (예: 4.7)
  String get formattedRating {
    return rating.toStringAsFixed(1);
  }

  bool get couponEnable => couponExistCount > 0;

  // 쿠폰 사용 함수
  History useCoupon() {
    // 쿠폰 사용 히스토리 생성
    final history = History(
      storeId: id,
      storeName: name,
      couponTitle: couponTitle,
      couponDescription: couponDescription,
    );

    // 쿠폰 사용 로직을 여기에 추가
    // 예: 쿠폰 사용 카운트 증가, 서버에 업데이트 등

    // 히스토리 반환
    return history;
  }

  // 쿠폰 사용 및 평점 추가를 동시에 처리
  History useCouponWithRating(int rating) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    // 쿠폰 사용 히스토리 생성 (평점 포함)
    final history = History(
      storeId: id,
      storeName: name,
      couponTitle: couponTitle,
      couponDescription: couponDescription,
      rating: rating,
    );

    // 쿠폰 사용 로직을 여기에 추가

    return history;
  }
}