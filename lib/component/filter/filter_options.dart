class FilterOptions {
  final int? cityId;
  final int? districtId;
  final List<int>? categories;

  const FilterOptions({
    this.cityId,
    this.districtId,
    this.categories,
  });

  // 복사본 생성 메서드
  FilterOptions copyWith({
    int? cityId,
    int? districtId,
    List<int>? categories,
  }) {
    return FilterOptions(
      cityId: cityId ?? this.cityId,
      districtId: districtId ?? this.districtId,
      categories: categories ?? this.categories,
    );
  }

  // 필터가 적용되었는지 여부 확인
  bool get hasFilter => cityId != null || districtId != null || (categories != null && categories!.isNotEmpty);

  // 필터 초기화
  FilterOptions reset() {
    return const FilterOptions();
  }
}