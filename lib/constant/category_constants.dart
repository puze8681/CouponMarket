// food_category_constants.dart

class FoodCategoryConstants {
  // 국가별 카테고리: 1000~1999 범위 사용
  static const int KOREAN = 1001;
  static const int CHINESE = 1002;
  static const int JAPANESE = 1003;
  static const int WESTERN = 1004;
  static const int ITALIAN = 1005;
  static const int FRENCH = 1006;
  static const int SPANISH = 1007;
  static const int AMERICAN = 1008;
  static const int EUROPEAN = 1009;
  static const int ASIAN = 1010;
  static const int VIETNAMESE = 1011;
  static const int THAI = 1012;
  static const int INDIAN = 1013;
  static const int MEXICAN = 1014;
  static const int SOUTH_AMERICAN = 1015;
  static const int FUSION = 1016;
  static const int OTHER_COUNTRY = 1099;

  // 종류별 카테고리

  // 1. 육류, 고기요리: 2000~2099 범위 사용
  static const int HANWOO = 2001;
  static const int BEEF = 2002;
  static const int PORK = 2003;
  static const int YAKITORI = 2004;
  static const int LAMB = 2005;
  static const int STEAK_RIBS = 2006;
  static const int BARBECUE = 2007;
  static const int JOKBAL_BOSSAM = 2008;
  static const int GOPCHANG_MAKCHANG = 2009;

  // 2. 해물, 생선요리: 2100~2199 범위 사용
  static const int SUSHI = 2101;
  static const int SASHIMI = 2102;
  static const int TUNA = 2103;
  static const int CRAB_LOBSTER = 2104;
  static const int SEAFOOD_SOUP_STEW = 2105;
  static const int OYSTER_SHELLFISH = 2106;

  // 3. 주점: 2200~2299 범위 사용
  static const int IZAKAYA = 2201;
  static const int WINE = 2202;
  static const int DINING_BAR = 2203;
  static const int TRADITIONAL_LIQUOR = 2204;
  static const int COCKTAIL_WHISKEY = 2205;
  static const int BEER_PUB = 2206;
  static const int ODEN_BAR = 2207;
  static const int PUB_WITH_FOOD = 2208;

  // 4. 카페&베이커리: 2300~2399 범위 사용
  static const int CAKE = 2301;
  static const int CAFE = 2302;
  static const int DESSERT = 2303;
  static const int BAKERY = 2304;

  // 5. 기타: 2400~2499 범위 사용
  static const int PASTA = 2401;
  static const int BRUNCH = 2402;
  static const int PIZZA = 2403;
  static const int TONKATSU = 2404;
  static const int HAMBURGER = 2405;
  static const int VEGETARIAN_VEGAN = 2406;
  static const int SHABU_SHABU = 2407;
  static const int CHICKEN = 2408;
  static const int DUCK = 2409;
  static const int RAMEN = 2410;
  static const int NAENGMYEON = 2411;
  static const int NOODLES = 2412;
  static const int JJIGAE_JEONGOL = 2413;
  static const int HOME_STYLE = 2414;
  static const int BUNSIK = 2415;
  static const int OTHER_TYPE = 2499;

  // 카테고리 이름 맵핑
  static Map<int, String> categoryNameMap = {
    // 국가별
    KOREAN: '한식',
    CHINESE: '중식',
    JAPANESE: '일식',
    WESTERN: '양식',
    ITALIAN: '이탈리안',
    FRENCH: '프렌치',
    SPANISH: '스페인',
    AMERICAN: '아메리칸',
    EUROPEAN: '유러피안',
    ASIAN: '아시안',
    VIETNAMESE: '베트남',
    THAI: '태국',
    INDIAN: '인도',
    MEXICAN: '멕시코',
    SOUTH_AMERICAN: '남미',
    FUSION: '퓨전',
    OTHER_COUNTRY: '기타 국가',

    // 육류, 고기요리
    HANWOO: '한우',
    BEEF: '소고기',
    PORK: '돼지고기',
    YAKITORI: '야키토리',
    LAMB: '양고기',
    STEAK_RIBS: '스테이크/립',
    BARBECUE: '바베큐',
    JOKBAL_BOSSAM: '족발/보쌈',
    GOPCHANG_MAKCHANG: '곱창/막창',

    // 해물, 생선요리
    SUSHI: '스시/초밥',
    SASHIMI: '회/사시미',
    TUNA: '참치회',
    CRAB_LOBSTER: '게/랍스터',
    SEAFOOD_SOUP_STEW: '해물(탕/찜/볶음)',
    OYSTER_SHELLFISH: '굴/조개',

    // 주점
    IZAKAYA: '이자카야',
    WINE: '와인',
    DINING_BAR: '다이닝바',
    TRADITIONAL_LIQUOR: '전통주',
    COCKTAIL_WHISKEY: '칵테일/위스키',
    BEER_PUB: '맥주/호프',
    ODEN_BAR: '오뎅바',
    PUB_WITH_FOOD: '요리주점',

    // 카페&베이커리
    CAKE: '케이크',
    CAFE: '카페',
    DESSERT: '디저트',
    BAKERY: '베이커리',

    // 기타
    PASTA: '파스타',
    BRUNCH: '브런치',
    PIZZA: '피자',
    TONKATSU: '돈가스',
    HAMBURGER: '햄버거',
    VEGETARIAN_VEGAN: '베지테리안/비건',
    SHABU_SHABU: '샤브샤브',
    CHICKEN: '닭 요리',
    DUCK: '오리 요리',
    RAMEN: '라멘',
    NAENGMYEON: '냉면',
    NOODLES: '국수',
    JJIGAE_JEONGOL: '찌개/전골',
    HOME_STYLE: '백반/가정식',
    BUNSIK: '분식',
    OTHER_TYPE: '기타 종류'
  };

  // 카테고리 그룹 맵핑
  static Map<String, List<int>> categoryGroups = {
    '국가별': [
      KOREAN, CHINESE, JAPANESE, WESTERN, ITALIAN, FRENCH, SPANISH,
      AMERICAN, EUROPEAN, ASIAN, VIETNAMESE, THAI, INDIAN, MEXICAN,
      SOUTH_AMERICAN, FUSION, OTHER_COUNTRY
    ],
    '육류/고기요리': [
      HANWOO, BEEF, PORK, YAKITORI, LAMB, STEAK_RIBS, BARBECUE,
      JOKBAL_BOSSAM, GOPCHANG_MAKCHANG
    ],
    '해물/생선요리': [
      SUSHI, SASHIMI, TUNA, CRAB_LOBSTER, SEAFOOD_SOUP_STEW, OYSTER_SHELLFISH
    ],
    '주점': [
      IZAKAYA, WINE, DINING_BAR, TRADITIONAL_LIQUOR, COCKTAIL_WHISKEY,
      BEER_PUB, ODEN_BAR, PUB_WITH_FOOD
    ],
    '카페/베이커리': [
      CAKE, CAFE, DESSERT, BAKERY
    ],
    '기타': [
      PASTA, BRUNCH, PIZZA, TONKATSU, HAMBURGER, VEGETARIAN_VEGAN,
      SHABU_SHABU, CHICKEN, DUCK, RAMEN, NAENGMYEON, NOODLES,
      JJIGAE_JEONGOL, HOME_STYLE, BUNSIK, OTHER_TYPE
    ]
  };

  // 카테고리 ID로 이름 가져오기
  static String getCategoryName(int categoryId) {
    return categoryNameMap[categoryId] ?? '알 수 없음';
  }

  // 카테고리 ID 리스트에서 카테고리 이름 리스트 가져오기
  static List<String> getCategoryNameList(List<int> categoryList) {
    List<String> nameList = [];

    for (int categoryId in categoryList) {
      String name = getCategoryName(categoryId);
      if (name != '알 수 없음') {
        nameList.add(name);
      }
    }

    return nameList;
  }

  // 특정 그룹에 속하는 카테고리인지 확인
  static bool isInGroup(int categoryId, String groupName) {
    List<int>? group = categoryGroups[groupName];
    return group != null && group.contains(categoryId);
  }

  // 특정 카테고리가 어떤 그룹에 속하는지 확인
  static String? getGroupName(int categoryId) {
    for (var entry in categoryGroups.entries) {
      if (entry.value.contains(categoryId)) {
        return entry.key;
      }
    }
    return null;
  }

  // 카테고리 ID 리스트에서 그룹명 리스트 가져오기
  static List<String> getGroupNameList(List<int> categoryList) {
    // 결과 저장할 Set (중복 제거)
    Set<String> groupSet = {};

    // 각 카테고리 ID에 대해 그룹명 확인 및 추가
    for (int categoryId in categoryList) {
      String? groupName = getGroupName(categoryId);
      if (groupName != null) {
        groupSet.add(groupName);
      }
    }

    // Set을 List로 변환하여 반환
    return groupSet.toList();
  }
}