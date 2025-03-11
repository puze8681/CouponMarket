import 'package:coupon_market/constant/category_constants.dart';
import 'package:coupon_market/constant/korean_constants.dart';
import 'package:coupon_market/model/store.dart';

class StoreDummyData {
  // 더미 매장 데이터 목록 반환
  static List<Store> getDummyStores() {
    return [
      // 서울 지역 매장
      Store(
        id: 'store_001',
        name: '서울 강남 한식당',
        description: '전통 한식을 현대적으로 재해석한 프리미엄 한식당입니다.',
        image: 'https://example.com/images/store001.jpg',
        phone: '02-1234-5678',
        address: '서울특별시 강남구 강남대로 123',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['한식', '고급', '데이트'],
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.HOME_STYLE],
        district: KoreanDistrictConstants.SEOUL_GANGNAM,
        city: KoreanCityConstants.SEOUL,
        couponCount: 24,
        userCount: 187,
      ),
      Store(
        id: 'store_002',
        name: '마포 돼지갈비',
        description: '30년 전통의 돼지갈비 전문점. 두툼한 고기와 특제 양념의 조화.',
        image: 'https://example.com/images/store002.jpg',
        phone: '02-2345-6789',
        address: '서울특별시 마포구 홍대로 45',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['돼지갈비', '맛집', '회식'],
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.PORK],
        district: KoreanDistrictConstants.SEOUL_MAPO,
        city: KoreanCityConstants.SEOUL,
        couponCount: 18,
        userCount: 156,
      ),
      Store(
        id: 'store_003',
        name: '서초 파스타 하우스',
        description: '이탈리아 현지 요리사가 만드는 정통 파스타와 피자',
        image: 'https://example.com/images/store003.jpg',
        phone: '02-3456-7890',
        address: '서울특별시 서초구 서초대로 78',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['파스타', '피자', '와인'],
        category: [FoodCategoryConstants.ITALIAN, FoodCategoryConstants.PASTA, FoodCategoryConstants.PIZZA],
        district: KoreanDistrictConstants.SEOUL_SEOCHO,
        city: KoreanCityConstants.SEOUL,
        couponCount: 15,
        userCount: 142,
      ),
      Store(
        id: 'store_004',
        name: '종로 쭈꾸미',
        description: '매콤한 쭈꾸미가 일품인 맛집. 다양한 해산물 요리도 제공합니다.',
        image: 'https://example.com/images/store004.jpg',
        phone: '02-4567-8901',
        address: '서울특별시 종로구 종로 12길 34',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['쭈꾸미', '해물', '매운맛'],
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.SEAFOOD_SOUP_STEW],
        district: KoreanDistrictConstants.SEOUL_JONGNO,
        city: KoreanCityConstants.SEOUL,
        couponCount: 12,
        userCount: 98,
      ),

      // 부산 지역 매장
      Store(
        id: 'store_005',
        name: '해운대 횟집',
        description: '부산 앞바다에서 직접 공수한 신선한 횟감으로 맛있는 회를 제공합니다.',
        image: 'https://example.com/images/store005.jpg',
        phone: '051-123-4567',
        address: '부산광역시 해운대구 해운대해변로 87',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['회', '해산물', '신선'],
        category: [FoodCategoryConstants.JAPANESE, FoodCategoryConstants.SASHIMI],
        district: KoreanDistrictConstants.BUSAN_HAEUNDAE,
        city: KoreanCityConstants.BUSAN,
        couponCount: 20,
        userCount: 175,
      ),
      Store(
        id: 'store_006',
        name: '부산진 돼지국밥',
        description: '40년 전통의 진한 국물이 일품인 부산식 돼지국밥 전문점',
        image: 'https://example.com/images/store006.jpg',
        phone: '051-234-5678',
        address: '부산광역시 부산진구 중앙대로 123',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['돼지국밥', '부산', '전통'],
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.PORK],
        district: KoreanDistrictConstants.BUSAN_BUSANJIN,
        city: KoreanCityConstants.BUSAN,
        couponCount: 16,
        userCount: 130,
      ),

      // 인천 지역 매장
      Store(
        id: 'store_007',
        name: '연수 중화요리',
        description: '정통 중국 요리부터 한국식 중화요리까지 다양하게 즐길 수 있는 곳',
        image: 'https://example.com/images/store007.jpg',
        phone: '032-123-4567',
        address: '인천광역시 연수구 센트럴로 56',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['중화요리', '짜장면', '탕수육'],
        category: [FoodCategoryConstants.CHINESE],
        district: KoreanDistrictConstants.INCHEON_YEONSU,
        city: KoreanCityConstants.INCHEON,
        couponCount: 14,
        userCount: 120,
      ),
      Store(
        id: 'store_008',
        name: '부평 치킨 & 맥주',
        description: '바삭한 치킨과 시원한 생맥주를 함께 즐길 수 있는 펍',
        image: 'https://example.com/images/store008.jpg',
        phone: '032-234-5678',
        address: '인천광역시 부평구 부평대로 78',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['치킨', '맥주', '안주'],
        category: [FoodCategoryConstants.CHICKEN, FoodCategoryConstants.BEER_PUB],
        district: KoreanDistrictConstants.INCHEON_BUPYEONG,
        city: KoreanCityConstants.INCHEON,
        couponCount: 13,
        userCount: 115,
      ),

      // 대전 지역 매장
      Store(
        id: 'store_009',
        name: '대전 소고기 구이',
        description: '엄선된 한우와 수입 소고기를 저렴한 가격에 즐길 수 있는 곳',
        image: 'https://example.com/images/store009.jpg',
        phone: '042-123-4567',
        address: '대전광역시 중구 대종로 123',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['소고기', '구이', '한우'],
        category: [FoodCategoryConstants.KOREAN, FoodCategoryConstants.BEEF, FoodCategoryConstants.HANWOO],
        district: 0, // 더미 데이터이므로 구/군 ID가 없다고 가정
        city: KoreanCityConstants.DAEJEON,
        couponCount: 10,
        userCount: 95,
      ),

      // 광주 지역 매장
      Store(
        id: 'store_010',
        name: '광주 카페',
        description: '광주 시내가 내려다보이는 전망 좋은 루프탑 카페',
        image: 'https://example.com/images/store010.jpg',
        phone: '062-123-4567',
        address: '광주광역시 동구 충장로 45',
        wifi: 'Y',
        toilet: 'Y',
        keyword: ['카페', '디저트', '루프탑'],
        category: [FoodCategoryConstants.CAFE, FoodCategoryConstants.DESSERT],
        district: 0, // 더미 데이터이므로 구/군 ID가 없다고 가정
        city: KoreanCityConstants.GWANGJU,
        couponCount: 8,
        userCount: 72,
      ),
    ];
  }

  // 특정 지역의 매장만 필터링하여 반환
  static List<Store> getStoresByCity(int cityId) {
    return getDummyStores().where((store) => store.city == cityId).toList();
  }

  // 특정 구/군의 매장만 필터링하여 반환
  static List<Store> getStoresByDistrict(int districtId) {
    return getDummyStores().where((store) => store.district == districtId).toList();
  }

  // 특정 카테고리의 매장만 필터링하여 반환
  static List<Store> getStoresByCategory(int categoryId) {
    return getDummyStores().where((store) => store.category.contains(categoryId)).toList();
  }

  // 복합 필터링 (지역 + 카테고리)
  static List<Store> getFilteredStores({int? cityId, int? districtId, List<int>? categories}) {
    List<Store> filteredStores = getDummyStores();

    if (cityId != null) {
      filteredStores = filteredStores.where((store) => store.city == cityId).toList();
    }

    if (districtId != null) {
      filteredStores = filteredStores.where((store) => store.district == districtId).toList();
    }

    if (categories != null && categories.isNotEmpty) {
      filteredStores = filteredStores.where((store) {
        for (int categoryId in categories) {
          if (store.category.contains(categoryId)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    return filteredStores;
  }

  // 랜덤 매장 하나 가져오기
  static Store getRandomStore() {
    final stores = getDummyStores();
    final random = DateTime.now().millisecondsSinceEpoch % stores.length;
    return stores[random];
  }
}