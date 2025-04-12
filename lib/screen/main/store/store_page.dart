import 'package:coupon_market/bloc/main/store/store_bloc.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/filter/category_filter_bottom_sheet.dart';
import 'package:coupon_market/component/filter/filter_options.dart';
import 'package:coupon_market/component/filter/location_filter_bottom_sheet.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/category_constants.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/korean_constants.dart';
import 'package:coupon_market/model/coupon.dart';
import 'package:coupon_market/screen/main/coupon/downloaded_coupons_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  final StoreBloc _bloc = StoreBloc();
  final ScrollController _scrollController = ScrollController();

  _onClickNotice() {
    Navigator.pushNamed(context, routeNotificationPage);
  }

  _onClickProfile() {
    Navigator.pushNamed(context, routeProfilePage);
  }

  _onClickCoupon(Coupon coupon) async {
    Navigator.pushNamed(context, routeCouponPage, arguments: {"coupon": coupon});
  }

  _onClickFab() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const DownloadedCouponsBottomSheet(),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _bloc.add(LoadMoreStore());
    }
  }

  // 지역 필터 바텀시트 표시
  void _showLocationFilter(FilterOptions currentFilterOptions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => LocationFilterBottomSheet(
          initialFilterOptions: currentFilterOptions,
          onApplyFilter: (filterOptions) {
            _bloc.add(ApplyFilter(filterOptions));
          },
        ),
      ),
    );
  }

  // 카테고리 필터 바텀시트 표시
  void _showCategoryFilter(FilterOptions currentFilterOptions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => CategoryFilterBottomSheet(
          initialFilterOptions: currentFilterOptions,
          onApplyFilter: (filterOptions) {
            _bloc.add(ApplyFilter(filterOptions));
          },
        ),
      ),
    );
  }

  // 도시 이름 조회 헬퍼 메서드
  String _getCityName(int? cityId) {
    if (cityId == null) return '';
    return KoreanCityConstants.cityNameMap[cityId] ?? '';
  }

  // 구/군 이름 조회 헬퍼 메서드
  String _getDistrictName(int? districtId) {
    if (districtId == null) return '';
    return KoreanDistrictConstants.districtNameMap[districtId] ?? '';
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitStore());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab,
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, StoreState state) {
            if (state.message != null) {
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, StoreState state) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        navigation,
                        filterWidget(state),
                        couponListWidget(state.couponList),
                      ],
                    ),
                  ),
                  if (state.isLoading) const IndicatorWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

extension on _StorePageState {
  Widget get navigation {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: BasicText("Coupon Market", 16, 20, FontWeight.w500),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: _onClickNotice,
                  child: Container(
                    color: Colors.transparent,
                    child: const AssetWidget(Assets.ic_profile_notice,
                        width: 24, height: 24),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _onClickProfile,
                  child: Container(
                    color: Colors.transparent,
                    child: const AssetWidget(Assets.ic_tab_my,
                        width: 28, height: 28, color: AppColors.mainText),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget filterWidget(StoreState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 지역 필터 버튼
          Expanded(
            child: GestureDetector(
              onTap: () => _showLocationFilter(state.filterOptions),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  state.filterOptions.cityId != null
                      ? '${_getCityName(state.filterOptions.cityId)} ${state.filterOptions.districtId != null ? _getDistrictName(state.filterOptions.districtId) : ''}'
                      : '지역으로 보기',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 카테고리 필터 버튼
          Expanded(
            child: GestureDetector(
              onTap: () => _showCategoryFilter(state.filterOptions),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  state.filterOptions.categories != null && state.filterOptions.categories!.isNotEmpty
                      ? state.filterOptions.categories!.map((category) => FoodCategoryConstants.getCategoryName(category)).join(", ")
                      : '카테고리로 보기',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget couponListWidget(List<Coupon> couponList){
    if (couponList.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('매장이 없습니다.'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: couponList.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final coupon = couponList[index];
          return couponWidget(coupon);
        },
      ),
    );
  }

  Widget couponWidget(Coupon coupon){
    return GestureDetector(
      onTap: () => _onClickCoupon(coupon),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // 매장 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  coupon.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.airplane_ticket_rounded, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 매장 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.storeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${coupon.tCity} ${coupon.tDistrict}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coupon.tCategory,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // 쿠폰 정보
              Column(
                children: [
                  Text(
                    '${coupon.stock}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Text(
                    '쿠폰',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on _StorePageState {
  Widget get _fab {
    return GestureDetector(
      onTap: _onClickFab,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const AssetWidget(Assets.ic_fab_coupon,
            width: 30, height: 30, color: Colors.white),
      ),
    );
  }
}
