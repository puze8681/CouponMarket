import 'package:coupon_market/constant/category_constants.dart';
import 'package:coupon_market/constant/korean_constants.dart';
import 'package:coupon_market/model/coupon.dart';

class CouponDummyData {
  // 더미 쿠폰 데이터 목록 반환
  static List<Coupon> getDummyCoupons() {
    // 현재 날짜 기준으로 날짜 계산
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));
    final nextMonth = DateTime(now.year, now.month + 1, now.day);
    final prevWeek = today.subtract(const Duration(days: 7));
    final prevMonth = DateTime(now.year, now.month - 1, now.day);
    final nextThreeMonths = DateTime(now.year, now.month + 3, now.day);

    return [
      // 서울 지역 쿠폰
      Coupon(
        id: 'coupon_001',
        storeId: 'store_001',
        storeName: '서울 강남 한식당',
        title: '점심 특선 10% 할인',
        description: '평일 11시부터 2시까지 모든 점심 메뉴 10% 할인',
        image: 'https://example.com/images/coupon001.jpg',
        stock: 50,
        code: '111111',
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.HOME_STYLE],
        district: KoreanDistrictConstants.SEOUL_GANGNAM,
        city: KoreanCityConstants.SEOUL,
        postStartAt: prevWeek,
        postEndAt: nextMonth,
        useStartAt: today,
        useEndAt: nextMonth,
      ),
      Coupon(
        id: 'coupon_002',
        storeId: 'store_001',
        storeName: '서울 강남 한식당',
        title: '디너 코스 2인 1인 무료',
        description: '디너 코스 2인 주문 시 1인 무료 혜택 (음료 및 주류 별도)',
        image: 'https://example.com/images/coupon002.jpg',
        stock: 20,
        code: '222222',
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.HOME_STYLE],
        district: KoreanDistrictConstants.SEOUL_GANGNAM,
        city: KoreanCityConstants.SEOUL,
        postStartAt: today,
        postEndAt: nextWeek,
        useStartAt: today,
        useEndAt: nextMonth,
      ),
      Coupon(
        id: 'coupon_003',
        storeId: 'store_002',
        storeName: '마포 돼지갈비',
        title: '갈비 1인분 추가 증정',
        description: '4인 이상 방문 시 돼지갈비 1인분 추가 무료 제공',
        image: 'https://example.com/images/coupon003.jpg',
        stock: 30,
        code: '333333',
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.PORK],
        district: KoreanDistrictConstants.SEOUL_MAPO,
        city: KoreanCityConstants.SEOUL,
        postStartAt: prevMonth,
        postEndAt: tomorrow,
        useStartAt: prevMonth,
        useEndAt: nextWeek,
      ),
      Coupon(
        id: 'coupon_004',
        storeId: 'store_003',
        storeName: '서초 파스타 하우스',
        title: '파스타 + 와인 세트 20% 할인',
        description: '파스타와 와인 세트 주문 시 20% 할인',
        image: 'https://example.com/images/coupon004.jpg',
        stock: 40,
        code: '44444',
        category: [FoodCategoryConstants.ITALIAN, FoodCategoryConstants.PASTA],
        district: KoreanDistrictConstants.SEOUL_SEOCHO,
        city: KoreanCityConstants.SEOUL,
        postStartAt: prevWeek,
        postEndAt: nextMonth,
        useStartAt: today,
        useEndAt: nextThreeMonths,
      ),

      // 부산 지역 쿠폰
      Coupon(
        id: 'coupon_005',
        storeId: 'store_005',
        storeName: '해운대 횟집',
        title: '모듬회 대 → 특대 업그레이드',
        description: '모듬회 대자 주문 시 특대 사이즈로 무료 업그레이드',
        image: 'https://example.com/images/coupon005.jpg',
        stock: 15,
        code: '555555',
        category: [FoodCategoryConstants.JAPANESE, FoodCategoryConstants.SASHIMI],
        district: KoreanDistrictConstants.BUSAN_HAEUNDAE,
        city: KoreanCityConstants.BUSAN,
        postStartAt: today,
        postEndAt: nextWeek,
        useStartAt: today,
        useEndAt: nextMonth,
      ),
      Coupon(
        id: 'coupon_006',
        storeId: 'store_006',
        storeName: '부산진 돼지국밥',
        title: '돼지국밥 1+1',
        description: '평일 오전 11시 이전 방문 시 동일 메뉴 1개 추가 제공',
        image: 'https://example.com/images/coupon006.jpg',
        stock: 25,
        code: '666666',
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.PORK],
        district: KoreanDistrictConstants.BUSAN_BUSANJIN,
        city: KoreanCityConstants.BUSAN,
        postStartAt: prevWeek,
        postEndAt: nextMonth,
        useStartAt: today,
        useEndAt: nextMonth,
      ),

      // 인천 지역 쿠폰
      Coupon(
        id: 'coupon_007',
        storeId: 'store_007',
        storeName: '연수 중화요리',
        title: '탕수육 주문 시 짜장면 서비스',
        description: '탕수육 주문 시 짜장면 1개 무료 제공 (테이크아웃 제외)',
        image: 'https://example.com/images/coupon007.jpg',
        stock: 35,
        code: '777777',
        category: [FoodCategoryConstants.CHINESE],
        district: KoreanDistrictConstants.INCHEON_YEONSU,
        city: KoreanCityConstants.INCHEON,
        postStartAt: prevMonth,
        postEndAt: nextWeek,
        useStartAt: prevMonth,
        useEndAt: nextMonth,
      ),
      Coupon(
        id: 'coupon_008',
        storeId: 'store_008',
        storeName: '부평 치킨 & 맥주',
        title: '맥주 2잔 무료',
        description: '치킨 2마리 주문 시 생맥주 500cc 2잔 무료 제공',
        image: 'https://example.com/images/coupon008.jpg',
        stock: 20,
        code: '888888',
        category: [FoodCategoryConstants.CHICKEN, FoodCategoryConstants.BEER_PUB],
        district: KoreanDistrictConstants.INCHEON_BUPYEONG,
        city: KoreanCityConstants.INCHEON,
        postStartAt: prevWeek,
        postEndAt: nextMonth,
        useStartAt: today,
        useEndAt: nextMonth,
      ),

      // 대전 지역 쿠폰
      Coupon(
        id: 'coupon_009',
        storeId: 'store_009',
        storeName: '대전 소고기 구이',
        title: '한우 등심 100g 추가 증정',
        description: '한우 등심 200g 이상 주문 시 100g 추가 증정',
        image: 'https://example.com/images/coupon009.jpg',
        stock: 10,
        code: '999999',
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.BEEF, FoodCategoryConstants.HANWOO],
        district: 0, // 더미 데이터이므로 구/군 ID가 없다고 가정
        city: KoreanCityConstants.DAEJEON,
        postStartAt: today,
        postEndAt: nextMonth,
        useStartAt: today,
        useEndAt: nextThreeMonths,
      ),

      // 광주 지역 쿠폰
      Coupon(
        id: 'coupon_010',
        storeId: 'store_010',
        storeName: '광주 카페',
        title: '아메리카노 1+1',
        description: '아메리카노 주문 시 동일 음료 1잔 추가 제공',
        image: 'https://example.com/images/coupon010.jpg',
        stock: 100,
        code: '101010',
        category: [FoodCategoryConstants.CAFE],
        district: 0, // 더미 데이터이므로 구/군 ID가 없다고 가정
        city: KoreanCityConstants.GWANGJU,
        postStartAt: prevWeek,
        postEndAt: nextMonth,
        useStartAt: today,
        useEndAt: nextMonth,
      ),
    ];
  }

  // 특정 지역의 쿠폰만 필터링하여 반환
  static List<Coupon> getCouponsByCity(int cityId) {
    return getDummyCoupons().where((coupon) => coupon.city == cityId).toList();
  }

  // 특정 구/군의 쿠폰만 필터링하여 반환
  static List<Coupon> getCouponsByDistrict(int districtId) {
    return getDummyCoupons().where((coupon) => coupon.district == districtId).toList();
  }

  // 특정 카테고리의 쿠폰만 필터링하여 반환
  static List<Coupon> getCouponsByCategory(int categoryId) {
    return getDummyCoupons().where((coupon) => coupon.category.contains(categoryId)).toList();
  }

  // 특정 매장의 쿠폰만 필터링하여 반환
  static List<Coupon> getCouponsByStore(String storeId) {
    return getDummyCoupons().where((coupon) => coupon.storeId == storeId).toList();
  }

  // 현재 사용 가능한 쿠폰만 필터링하여 반환 (게시 중이고, 사용 기간이 유효한 쿠폰)
  static List<Coupon> getAvailableCoupons() {
    final now = DateTime.now();
    return getDummyCoupons().where((coupon) {
      return coupon.postStartAt.isBefore(now) &&
          coupon.postEndAt.isAfter(now) &&
          coupon.useStartAt.isBefore(now) &&
          coupon.useEndAt.isAfter(now) &&
          coupon.stock > 0;
    }).toList();
  }

  // 복합 필터링 (지역 + 카테고리 + 유효성)
  static List<Coupon> getFilteredCoupons({
    int? cityId,
    int? districtId,
    List<int>? categories,
    bool onlyAvailable = true,
  }) {
    List<Coupon> filteredCoupons = onlyAvailable ? getAvailableCoupons() : getDummyCoupons();

    if (cityId != null) {
      filteredCoupons = filteredCoupons.where((coupon) => coupon.city == cityId).toList();
    }

    if (districtId != null) {
      filteredCoupons = filteredCoupons.where((coupon) => coupon.district == districtId).toList();
    }

    if (categories != null && categories.isNotEmpty) {
      filteredCoupons = filteredCoupons.where((coupon) {
        for (int categoryId in categories) {
          if (coupon.category.contains(categoryId)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    return filteredCoupons;
  }

  // 곧 만료되는 쿠폰 가져오기 (N일 이내)
  static List<Coupon> getSoonExpiringCoupons({int daysThreshold = 7}) {
    final now = DateTime.now();
    final thresholdDate = now.add(Duration(days: daysThreshold));

    return getAvailableCoupons().where((coupon) {
      return coupon.useEndAt.isBefore(thresholdDate) && coupon.useEndAt.isAfter(now);
    }).toList();
  }

  // 신규 쿠폰 가져오기 (최근 N일 이내 게시 시작)
  static List<Coupon> getNewCoupons({int daysThreshold = 3}) {
    final now = DateTime.now();
    final thresholdDate = now.subtract(Duration(days: daysThreshold));

    return getAvailableCoupons().where((coupon) {
      return coupon.postStartAt.isAfter(thresholdDate);
    }).toList();
  }

  // 남은 수량 기준으로 정렬된 쿠폰 목록 가져오기 (희소성 높은 순)
  static List<Coupon> getCouponsSortedByRemainingStock({bool ascending = true}) {
    final availableCoupons = getAvailableCoupons();
    availableCoupons.sort((a, b) => ascending ? a.stock.compareTo(b.stock) : b.stock.compareTo(a.stock));
    return availableCoupons;
  }

  // 랜덤 쿠폰 하나 가져오기
  static Coupon getRandomCoupon() {
    final coupons = getAvailableCoupons();
    final random = DateTime.now().millisecondsSinceEpoch % coupons.length;
    return coupons[random];
  }
}