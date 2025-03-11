import 'package:coupon_market/component/filter/filter_options.dart';
import 'package:coupon_market/constant/category_constants.dart';
import 'package:flutter/material.dart';

class CategoryFilterBottomSheet extends StatefulWidget {
  final FilterOptions initialFilterOptions;
  final Function(FilterOptions) onApplyFilter;

  const CategoryFilterBottomSheet({
    super.key,
    required this.initialFilterOptions,
    required this.onApplyFilter,
  });

  @override
  _CategoryFilterBottomSheetState createState() => _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  // 로컬 카테고리 선택 상태
  late List<int> _selectedCategories;

  @override
  void initState() {
    super.initState();
    // 현재 카테고리 선택 상태 복사
    _selectedCategories = widget.initialFilterOptions.categories != null
        ? List<int>.from(widget.initialFilterOptions.categories!)
        : [];
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
                  '카테고리 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 카테고리 목록
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _buildCategoryGroups(),
                ),
              ),
            ),
          ),

          // 하단 버튼 영역
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Row(
                children: [
                  // 초기화 버튼
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategories = [];
                      });
                    },
                    child: const Text('초기화'),
                  ),
                  const SizedBox(width: 8),
                  // 적용 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 필터 상태 업데이트 및 결과 반환
                        FilterOptions filterOptions = FilterOptions(
                          cityId: widget.initialFilterOptions.cityId,
                          districtId: widget.initialFilterOptions.districtId,
                          categories: _selectedCategories.isEmpty ? null : _selectedCategories,
                        );

                        widget.onApplyFilter(filterOptions);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '적용하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리 그룹 위젯 생성
  List<Widget> _buildCategoryGroups() {
    List<Widget> groupWidgets = [];

    // FoodCategoryConstants의 카테고리 그룹 사용
    FoodCategoryConstants.categoryGroups.forEach((groupName, categoryIds) {
      groupWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                groupName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoryIds.map((categoryId) {
                String categoryName = FoodCategoryConstants.getCategoryName(categoryId);
                return FilterChip(
                  label: Text(categoryName),
                  selected: _selectedCategories.contains(categoryId),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(categoryId);
                      } else {
                        _selectedCategories.remove(categoryId);
                      }
                    });
                  },
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue[800],
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 24),
          ],
        ),
      );
    });

    return groupWidgets;
  }
}