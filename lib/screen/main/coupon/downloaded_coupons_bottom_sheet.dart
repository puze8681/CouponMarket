import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:coupon_market/model/user_coupon.dart';

class DownloadedCouponsBottomSheet extends StatefulWidget {
  const DownloadedCouponsBottomSheet({Key? key}) : super(key: key);

  @override
  State<DownloadedCouponsBottomSheet> createState() => _DownloadedCouponsBottomSheetState();
}

class _DownloadedCouponsBottomSheetState extends State<DownloadedCouponsBottomSheet> {
  List<UserCoupon> _coupons = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 10;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 이벤트 리스너
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreCoupons();
    }
  }

  // 날짜 포맷 함수
  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  // 첫 페이지 쿠폰 목록 불러오기
  Future<void> _loadCoupons() async {
    try {
      final (coupons, lastDoc) = await fireStoreManager.getUserCouponList(_pageSize, null);

      if (mounted) {
        setState(() {
          _coupons = coupons;
          _lastDocument = lastDoc;
          _isLoading = false;
          _hasMoreData = lastDoc != null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '쿠폰을 불러오는 중 오류가 발생했습니다';
          _isLoading = false;
        });
      }
    }
  }

  // 추가 쿠폰 목록 불러오기
  Future<void> _loadMoreCoupons() async {
    if (!_hasMoreData || _lastDocument == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final (moreCoupons, lastDoc) = await fireStoreManager.getUserCouponList(_pageSize, _lastDocument);

      if (mounted) {
        setState(() {
          _coupons.addAll(moreCoupons);
          _lastDocument = lastDoc;
          _isLoadingMore = false;
          _hasMoreData = lastDoc != null && moreCoupons.isNotEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          // 추가 로딩 중 에러는 스낵바로만 표시
          Fluttertoast.showToast(msg: '추가 쿠폰을 불러오는 중 오류가 발생했습니다');
        });
      }
    }
  }

  // 쿠폰 사용 상태 확인
  bool _isExpired(DateTime endDate) {
    return DateTime.now().isAfter(endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 바텀시트 핸들
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          // 제목
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '내 쿠폰함',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _loadCoupons();
                  },
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // 쿠폰 목록 (또는 로딩/에러 상태)
          Flexible(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.grey[700]),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadCoupons();
              },
              child: Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_coupons.isEmpty) {
      return EmptyState(
        icon: Icons.confirmation_num_outlined,
        title: '다운로드한 쿠폰이 없습니다',
        description: '쿠폰을 다운로드하여 다양한 혜택을 누려보세요!',
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: _coupons.length + (_isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) =>
      index < _coupons.length - 1
          ? Divider(height: 1, indent: 16, endIndent: 16)
          : SizedBox.shrink(),
      itemBuilder: (context, index) {
        // 로딩 인디케이터 표시 (리스트 마지막에)
        if (index == _coupons.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final coupon = _coupons[index];
        final isExpired = _isExpired(coupon.useEndAt);

        return InkWell(
          onTap: () {
            // 쿠폰 상세 페이지로 이동
            Navigator.of(context).pop(); // 바텀시트 닫기
            Navigator.pushNamed(context, routeCouponPage, arguments: {"coupon": coupon.toCoupon()});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 쿠폰 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: coupon.image.isNotEmpty
                      ? Image.network(
                    coupon.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[500]),
                    ),
                  )
                      : Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: Icon(Icons.confirmation_num, color: Colors.grey[500]),
                  ),
                ),

                SizedBox(width: 16),

                // 쿠폰 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              coupon.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isExpired ? Colors.grey : Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isExpired)
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '사용기간 만료',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 4),

                      Text(
                        coupon.storeName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),

                      SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.event_available,
                            size: 14,
                            color: isExpired ? Colors.grey[400] : Colors.blue[700],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '~ ${_formatDate(coupon.useEndAt)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isExpired ? Colors.grey[500] : Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 오른쪽 아이콘
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// EmptyState 위젯 (없는 경우 구현해야 합니다)
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}