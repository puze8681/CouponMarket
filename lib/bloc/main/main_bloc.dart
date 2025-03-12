import 'package:coupon_market/component/filter/filter_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/coupon.dart';
import 'package:coupon_market/model/coupon_dummy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 이벤트 정의
abstract class MainEvent {}
class InitMain extends MainEvent {}
class LoadMoreMain extends MainEvent {}
class ApplyFilter extends MainEvent {
  final FilterOptions filterOptions;
  ApplyFilter(this.filterOptions);
}
class ResetFilter extends MainEvent {}

// 상태 정의
class MainState {
  final List<Coupon> couponList;
  final bool isLoading;
  final String? message;
  final FilterOptions filterOptions;
  final bool isFiltered; // 필터가 적용되었는지 여부

  MainState(
      this.couponList, {
        this.isLoading = false,
        this.message,
        this.filterOptions = const FilterOptions(),
        this.isFiltered = false,
      });

  // 복사본 생성 메서드
  MainState copyWith({
    List<Coupon>? couponList,
    bool? isLoading,
    String? message,
    FilterOptions? filterOptions,
    bool? isFiltered,
  }) {
    return MainState(
      // couponList ?? this.couponList,
      CouponDummyData.getDummyCoupons(),
      isLoading: isLoading ?? this.isLoading,
      message: message,
      filterOptions: filterOptions ?? this.filterOptions,
      isFiltered: isFiltered ?? this.isFiltered,
    );
  }
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState([])) {
    on<InitMain>(_onInit);
    on<LoadMoreMain>(_onLoadMore);
    on<ApplyFilter>(_onApplyFilter);
    on<ResetFilter>(_onResetFilter);
  }

  DocumentSnapshot? lastDocument;
  bool isLastPage = false;
  bool isLoadEnable = true;

  Future<void> _onInit(InitMain event, Emitter<MainState> emit) async {
    try {
      emit(state.copyWith(couponList: [], isLoading: true));

      final (couponList, documentSnapshot) = await _loadCoupons(
        limit: 10,
        filterOptions: state.filterOptions,
      );

      lastDocument = documentSnapshot;
      isLastPage = couponList.length < 10;

      emit(state.copyWith(
        couponList: couponList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        couponList: [],
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(LoadMoreMain event, Emitter<MainState> emit) async {
    if (isLoadEnable && !isLastPage) {
      isLoadEnable = false;
      try {
        emit(state.copyWith(isLoading: true));

        final (couponList, documentSnapshot) = await _loadCoupons(
          limit: 10,
          lastDocument: lastDocument,
          filterOptions: state.filterOptions,
        );

        lastDocument = documentSnapshot;
        isLastPage = couponList.length < 10;

        List<Coupon> newCouponList = [...state.couponList, ...couponList];

        emit(state.copyWith(
          couponList: newCouponList,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          message: e.toString(),
        ));
      }
      isLoadEnable = true;
    }
  }

  Future<void> _onApplyFilter(ApplyFilter event, Emitter<MainState> emit) async {
    try {
      // 필터가 변경되면 상태를 초기화
      lastDocument = null;
      isLastPage = false;

      emit(state.copyWith(
        couponList: [],
        isLoading: true,
        filterOptions: event.filterOptions,
        isFiltered: event.filterOptions.hasFilter,
      ));

      final (couponList, documentSnapshot) = await _loadCoupons(
        limit: 10,
        filterOptions: event.filterOptions,
      );

      lastDocument = documentSnapshot;
      isLastPage = couponList.length < 10;

      emit(state.copyWith(
        couponList: couponList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        couponList: [],
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onResetFilter(ResetFilter event, Emitter<MainState> emit) async {
    // 필터 리셋하고 초기 상태로 돌아감
    add(ApplyFilter(FilterOptions()));
  }

  // 매장 목록 로드 메서드 (필터 옵션 적용)
  Future<(List<Coupon>, DocumentSnapshot?)> _loadCoupons({
    required int limit,
    DocumentSnapshot? lastDocument,
    required FilterOptions filterOptions,
  }) async {
    return fireStoreManager.getCouponList(
      limit: limit,
      lastDocument: lastDocument,
      cityId: filterOptions.cityId,
      districtId: filterOptions.districtId,
      categories: filterOptions.categories,
    );
  }
}