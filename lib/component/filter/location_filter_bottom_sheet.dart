import 'package:coupon_market/component/filter/filter_options.dart';
import 'package:coupon_market/constant/korean_constants.dart';
import 'package:flutter/material.dart';

// 지역 필터 바텀시트
class LocationFilterBottomSheet extends StatefulWidget {
  final FilterOptions initialFilterOptions;
  final Function(FilterOptions) onApplyFilter;

  const LocationFilterBottomSheet({
    super.key,
    required this.initialFilterOptions,
    required this.onApplyFilter,
  });

  @override
  _LocationFilterBottomSheetState createState() => _LocationFilterBottomSheetState();
}

class _LocationFilterBottomSheetState extends State<LocationFilterBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentTabIndex = 0;

  // 로컬 필터 상태
  late int? _selectedCityId;
  late int? _selectedDistrictId;

  @override
  void initState() {
    super.initState();
    _selectedCityId = widget.initialFilterOptions.cityId;
    _selectedDistrictId = widget.initialFilterOptions.districtId;

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
          _pageController.animateToPage(
            _currentTabIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 상단 핸들과 제목
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 드래그 핸들
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '지역 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 탭 버튼
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _tabController.animateTo(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _currentTabIndex == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _currentTabIndex == 0
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '지역으로 보기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _tabController.animateTo(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _currentTabIndex == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _currentTabIndex == 1
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '지하철역으로 보기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 페이지 뷰
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                  _tabController.animateTo(index);
                });
              },
              children: [
                // 지역으로 보기 페이지
                _buildRegionsPage(),

                // 지하철역으로 보기 페이지 (예시로만 구현)
                _buildSubwayPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 지역으로 보기 페이지
  Widget _buildRegionsPage() {
    return Row(
      children: [
        // 왼쪽 열 - 도시 목록
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.grey[100],
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildCityList(),
            ),
          ),
        ),

        // 오른쪽 열 - 구/군 목록
        Expanded(
          flex: 5,
          child: _selectedCityId != null
              ? ListView(
            padding: EdgeInsets.zero,
            children: _buildDistrictList(),
          )
              : const Center(
            child: Text('도시를 선택해주세요'),
          ),
        ),
      ],
    );
  }

  // 도시 목록 아이템 생성
  List<Widget> _buildCityList() {
    List<Widget> cityWidgets = [];

    // KoreanCityConstants에서 도시 정보 가져오기
    KoreanCityConstants.cityNameMap.forEach((cityId, cityName) {
      cityWidgets.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedCityId = cityId;
              _selectedDistrictId = null; // 도시 변경 시 구/군 초기화
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: _selectedCityId == cityId
                  ? Colors.white
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 0.5,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              cityName,
              style: TextStyle(
                fontWeight: _selectedCityId == cityId
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });

    return cityWidgets;
  }

  // 구/군 목록 아이템 생성
  List<Widget> _buildDistrictList() {
    List<Widget> districtWidgets = [];

    if (_selectedCityId != null) {
      List<int> districtIds = KoreanDistrictConstants.getDistrictsByCityId(
        _selectedCityId!,
      );

      for (int districtId in districtIds) {
        String? districtName = KoreanDistrictConstants.districtNameMap[districtId];
        if (districtName != null) {
          districtWidgets.add(
            InkWell(
              onTap: () {
                setState(() {
                  _selectedDistrictId = districtId;
                });

                // 필터 상태 업데이트 및 결과 반환
                FilterOptions filterOptions = FilterOptions(
                  cityId: _selectedCityId,
                  districtId: _selectedDistrictId,
                  categories: widget.initialFilterOptions.categories,
                );

                widget.onApplyFilter(filterOptions);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      districtName,
                      style: TextStyle(
                        fontWeight: _selectedDistrictId == districtId
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (_selectedDistrictId == districtId)
                      const Icon(
                        Icons.check,
                        color: Colors.blue,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }

    return districtWidgets;
  }

  // 지하철역으로 보기 페이지 (예시만 구현)
  Widget _buildSubwayPage() {
    return const Center(
      child: Text('지하철역 기능은 준비 중입니다'),
    );
  }
}