// korean_city_constants.dart

class KoreanCityConstants {
  // 광역시/도 상수 (시 단위)
  static const int SEOUL = 1;
  static const int BUSAN = 2;
  static const int DAEGU = 3;
  static const int INCHEON = 4;
  static const int GWANGJU = 5;
  static const int DAEJEON = 6;
  static const int ULSAN = 7;
  static const int SEJONG = 8;
  static const int GYEONGGI = 9;
  static const int GANGWON = 10;
  static const int CHUNGBUK = 11;
  static const int CHUNGNAM = 12;
  static const int JEONBUK = 13;
  static const int JEONNAM = 14;
  static const int GYEONGBUK = 15;
  static const int GYEONGNAM = 16;
  static const int JEJU = 17;

  // 시/도 이름 맵핑 (int -> String)
  static Map<int, String> cityNameMap = {
    SEOUL: '서울특별시',
    BUSAN: '부산광역시',
    DAEGU: '대구광역시',
    INCHEON: '인천광역시',
    GWANGJU: '광주광역시',
    DAEJEON: '대전광역시',
    ULSAN: '울산광역시',
    SEJONG: '세종특별자치시',
    GYEONGGI: '경기도',
    GANGWON: '강원특별자치도',
    CHUNGBUK: '충청북도',
    CHUNGNAM: '충청남도',
    JEONBUK: '전라북도',
    JEONNAM: '전라남도',
    GYEONGBUK: '경상북도',
    GYEONGNAM: '경상남도',
    JEJU: '제주특별자치도',
  };
}

class KoreanDistrictConstants {
  // 서울 구 단위
  static const int SEOUL_JONGNO = 101;
  static const int SEOUL_JUNG = 102;
  static const int SEOUL_YONGSAN = 103;
  static const int SEOUL_SEONGDONG = 104;
  static const int SEOUL_GWANGJIN = 105;
  static const int SEOUL_DONGDAEMUN = 106;
  static const int SEOUL_JUNGNANG = 107;
  static const int SEOUL_SEONGBUK = 108;
  static const int SEOUL_GANGBUK = 109;
  static const int SEOUL_DOBONG = 110;
  static const int SEOUL_NOWON = 111;
  static const int SEOUL_EUNPYEONG = 112;
  static const int SEOUL_SEODAEMUN = 113;
  static const int SEOUL_MAPO = 114;
  static const int SEOUL_YANGCHEON = 115;
  static const int SEOUL_GANGSEO = 116;
  static const int SEOUL_GURO = 117;
  static const int SEOUL_GEUMCHEON = 118;
  static const int SEOUL_YEONGDEUNGPO = 119;
  static const int SEOUL_DONGJAK = 120;
  static const int SEOUL_GWANAK = 121;
  static const int SEOUL_SEOCHO = 122;
  static const int SEOUL_GANGNAM = 123;
  static const int SEOUL_SONGPA = 124;
  static const int SEOUL_GANGDONG = 125;

  // 부산 구 단위
  static const int BUSAN_JUNG = 201;
  static const int BUSAN_SEO = 202;
  static const int BUSAN_DONG = 203;
  static const int BUSAN_YEONGDO = 204;
  static const int BUSAN_BUSANJIN = 205;
  static const int BUSAN_DONGNAE = 206;
  static const int BUSAN_NAM = 207;
  static const int BUSAN_BUK = 208;
  static const int BUSAN_HAEUNDAE = 209;
  static const int BUSAN_SAHA = 210;
  static const int BUSAN_GEUMJEONG = 211;
  static const int BUSAN_GANGSEO = 212;
  static const int BUSAN_YEONJE = 213;
  static const int BUSAN_SUYEONG = 214;
  static const int BUSAN_SASANG = 215;
  static const int BUSAN_GIJANG = 216;

  // 인천 구 단위
  static const int INCHEON_JUNG = 401;
  static const int INCHEON_DONG = 402;
  static const int INCHEON_MICHUHOL = 403;
  static const int INCHEON_YEONSU = 404;
  static const int INCHEON_NAMDONG = 405;
  static const int INCHEON_BUPYEONG = 406;
  static const int INCHEON_GYEYANG = 407;
  static const int INCHEON_SEO = 408;
  static const int INCHEON_GANGHWA = 409;
  static const int INCHEON_ONGJIN = 410;

  // 주요 구 이름 맵핑 (int -> String)
  static Map<int, String> districtNameMap = {
    // 서울
    SEOUL_JONGNO: '종로구',
    SEOUL_JUNG: '중구',
    SEOUL_YONGSAN: '용산구',
    SEOUL_SEONGDONG: '성동구',
    SEOUL_GWANGJIN: '광진구',
    SEOUL_DONGDAEMUN: '동대문구',
    SEOUL_JUNGNANG: '중랑구',
    SEOUL_SEONGBUK: '성북구',
    SEOUL_GANGBUK: '강북구',
    SEOUL_DOBONG: '도봉구',
    SEOUL_NOWON: '노원구',
    SEOUL_EUNPYEONG: '은평구',
    SEOUL_SEODAEMUN: '서대문구',
    SEOUL_MAPO: '마포구',
    SEOUL_YANGCHEON: '양천구',
    SEOUL_GANGSEO: '강서구',
    SEOUL_GURO: '구로구',
    SEOUL_GEUMCHEON: '금천구',
    SEOUL_YEONGDEUNGPO: '영등포구',
    SEOUL_DONGJAK: '동작구',
    SEOUL_GWANAK: '관악구',
    SEOUL_SEOCHO: '서초구',
    SEOUL_GANGNAM: '강남구',
    SEOUL_SONGPA: '송파구',
    SEOUL_GANGDONG: '강동구',

    // 부산
    BUSAN_JUNG: '중구',
    BUSAN_SEO: '서구',
    BUSAN_DONG: '동구',
    BUSAN_YEONGDO: '영도구',
    BUSAN_BUSANJIN: '부산진구',
    BUSAN_DONGNAE: '동래구',
    BUSAN_NAM: '남구',
    BUSAN_BUK: '북구',
    BUSAN_HAEUNDAE: '해운대구',
    BUSAN_SAHA: '사하구',
    BUSAN_GEUMJEONG: '금정구',
    BUSAN_GANGSEO: '강서구',
    BUSAN_YEONJE: '연제구',
    BUSAN_SUYEONG: '수영구',
    BUSAN_SASANG: '사상구',
    BUSAN_GIJANG: '기장군',

    // 인천
    INCHEON_JUNG: '중구',
    INCHEON_DONG: '동구',
    INCHEON_MICHUHOL: '미추홀구',
    INCHEON_YEONSU: '연수구',
    INCHEON_NAMDONG: '남동구',
    INCHEON_BUPYEONG: '부평구',
    INCHEON_GYEYANG: '계양구',
    INCHEON_SEO: '서구',
    INCHEON_GANGHWA: '강화군',
    INCHEON_ONGJIN: '옹진군',
  };

  // 특정 시에 속한 구 목록 반환하는 메서드
  static List<int> getDistrictsByCityId(int cityId) {
    switch (cityId) {
      case KoreanCityConstants.SEOUL:
        return [
          SEOUL_JONGNO, SEOUL_JUNG, SEOUL_YONGSAN, SEOUL_SEONGDONG, SEOUL_GWANGJIN,
          SEOUL_DONGDAEMUN, SEOUL_JUNGNANG, SEOUL_SEONGBUK, SEOUL_GANGBUK, SEOUL_DOBONG,
          SEOUL_NOWON, SEOUL_EUNPYEONG, SEOUL_SEODAEMUN, SEOUL_MAPO, SEOUL_YANGCHEON,
          SEOUL_GANGSEO, SEOUL_GURO, SEOUL_GEUMCHEON, SEOUL_YEONGDEUNGPO, SEOUL_DONGJAK,
          SEOUL_GWANAK, SEOUL_SEOCHO, SEOUL_GANGNAM, SEOUL_SONGPA, SEOUL_GANGDONG
        ];
      case KoreanCityConstants.BUSAN:
        return [
          BUSAN_JUNG, BUSAN_SEO, BUSAN_DONG, BUSAN_YEONGDO, BUSAN_BUSANJIN,
          BUSAN_DONGNAE, BUSAN_NAM, BUSAN_BUK, BUSAN_HAEUNDAE, BUSAN_SAHA,
          BUSAN_GEUMJEONG, BUSAN_GANGSEO, BUSAN_YEONJE, BUSAN_SUYEONG, BUSAN_SASANG,
          BUSAN_GIJANG
        ];
      case KoreanCityConstants.INCHEON:
        return [
          INCHEON_JUNG, INCHEON_DONG, INCHEON_MICHUHOL, INCHEON_YEONSU, INCHEON_NAMDONG,
          INCHEON_BUPYEONG, INCHEON_GYEYANG, INCHEON_SEO, INCHEON_GANGHWA, INCHEON_ONGJIN
        ];
      default:
        return [];
    }
  }
}