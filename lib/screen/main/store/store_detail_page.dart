import 'package:coupon_market/bloc/main/store/store_detail_bloc.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/model/store.dart';
import 'package:coupon_market/screen/main/coupon/coupon_pin_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StoreDetailPage extends StatefulWidget {
  final Store store;

  const StoreDetailPage({super.key, required this.store});

  @override
  State createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> with TickerProviderStateMixin {
  final StoreDetailBloc _bloc = StoreDetailBloc();

  Store get store => widget.store;

  _onClickBack() {
    Navigator.pop(context);
  }

  _onClickUse() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CouponPinModal(
        store: store,
        onUse: (){
          _bloc.add(UseStoreDetail(store));
        },
      ),
    );
  }
  _onClickDownload() async {
    _bloc.add(DownloadStoreDetail(store));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, StoreDetailState state) {
            if (state.message != null) {
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, StoreDetailState state) {
              bool isLoading = state.isLoading;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        navigation,
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (store.image.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(store.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),

                                // 쿠폰 정보 카드
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // 쿠폰 제목 및 재고 정보
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              store.couponTitle,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '남은 수량: ${store.couponExistCount}장',
                                              style: TextStyle(
                                                color: Colors.blue[800],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // 카테고리 및 위치 정보
                                      Wrap(
                                        spacing: 8,
                                        children: [
                                          ...store.tCategoryList.map(
                                            (category) => Chip(
                                              label: Text(category),
                                              backgroundColor: Colors.grey[200],
                                            ),
                                          ),
                                          Chip(
                                            label: Text(
                                                '${store.tCity} ${store.tDistrict}'),
                                            backgroundColor: Colors.grey[200],
                                            avatar: const Icon(Icons.location_on,
                                                size: 16),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // 쿠폰 설명
                                      const Text(
                                        '쿠폰 설명',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        store.description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // 매장 정보 영역 (store가 있을 때만 표시)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '매장 정보',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12),

                                            // 매장 정보 행
                                            _buildStoreInfoRow(Icons.store, '매장명', store.name),
                                            _buildStoreInfoRow(Icons.description, '매장 설명', store.description),
                                            _buildStoreInfoRow(Icons.phone, '전화번호', store.phone),
                                            _buildStoreInfoRow(Icons.location_on, '주소', store.address),
                                            _buildStoreInfoRow(Icons.wifi, 'Wi-Fi', store.wifi),
                                            _buildStoreInfoRow(Icons.wc, '화장실', store.toilet),

                                            // 매장 키워드
                                            if (store.keyword.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.tag,
                                                      color: Colors.blue[700],
                                                      size: 20),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      children: store.keyword
                                                              .map(
                                                                (keyword) =>
                                                                    Container(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .blue[50],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    border: Border.all(
                                                                        color:
                                                                            Colors.blue[200]!),
                                                                  ),
                                                                  child: Text(
                                                                    '#$keyword',
                                                                    style: TextStyle(
                                                                        color:
                                                                            Colors.blue[700]),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 40),

                                      // 다운로드 버튼
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 56,
                                              child: ElevatedButton(
                                                onPressed: isLoading
                                                    ? null
                                                    : _onClickUse,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.lightBlueAccent,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: isLoading
                                                    ? const CircularProgressIndicator(
                                                    color: Colors.white)
                                                    : const Text(
                                                  '쿠폰 사용',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: SizedBox(
                                              height: 56,
                                              child: ElevatedButton(
                                                onPressed: isLoading
                                                    ? null
                                                    : _onClickDownload,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: isLoading
                                                    ? const CircularProgressIndicator(
                                                    color: Colors.white)
                                                    : const Text(
                                                  '쿠폰 저장',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
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

extension on _StoreDetailPageState {
  Widget get navigation {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: BasicText(store.name, 16, 20, FontWeight.w500),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _onClickBack,
                  child: Container(
                    color: Colors.transparent,
                    child: const AssetWidget(Assets.ic_back,
                        width: 24, height: 24),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 매장 정보 행 위젯
  Widget _buildStoreInfoRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}