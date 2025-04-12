import 'package:coupon_market/component/filter/filter_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/store.dart';
import 'package:coupon_market/model/store_dummy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 이벤트 정의
abstract class StoreEvent {}
class InitStore extends StoreEvent {}
class LoadMoreStore extends StoreEvent {}
class ApplyFilter extends StoreEvent {
  final FilterOptions filterOptions;
  ApplyFilter(this.filterOptions);
}
class ResetFilter extends StoreEvent {}

// 상태 정의
class StoreState {
  final List<Store> storeList;
  final bool isLoading;
  final String? message;
  final FilterOptions filterOptions;
  final bool isFiltered; // 필터가 적용되었는지 여부

  StoreState(
      this.storeList, {
        this.isLoading = false,
        this.message,
        this.filterOptions = const FilterOptions(),
        this.isFiltered = false,
      });

  // 복사본 생성 메서드
  StoreState copyWith({
    List<Store>? storeList,
    bool? isLoading,
    String? message,
    FilterOptions? filterOptions,
    bool? isFiltered,
  }) {
    return StoreState(
      // storeList ?? this.storeList,
      StoreDummyData.getDummyStores(),
      isLoading: isLoading ?? this.isLoading,
      message: message,
      filterOptions: filterOptions ?? this.filterOptions,
      isFiltered: isFiltered ?? this.isFiltered,
    );
  }
}

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState([])) {
    on<InitStore>(_onInit);
    on<LoadMoreStore>(_onLoadMore);
    on<ApplyFilter>(_onApplyFilter);
    on<ResetFilter>(_onResetFilter);
  }

  DocumentSnapshot? lastDocument;
  bool isLastPage = false;
  bool isLoadEnable = true;

  Future<void> _onInit(InitStore event, Emitter<StoreState> emit) async {
    try {
      emit(state.copyWith(storeList: [], isLoading: true));

      final (storeList, documentSnapshot) = await _loadStores(
        limit: 10,
        filterOptions: state.filterOptions,
      );

      lastDocument = documentSnapshot;
      isLastPage = storeList.length < 10;

      emit(state.copyWith(
        storeList: storeList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        storeList: [],
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(LoadMoreStore event, Emitter<StoreState> emit) async {
    if (isLoadEnable && !isLastPage) {
      isLoadEnable = false;
      try {
        emit(state.copyWith(isLoading: true));

        final (storeList, documentSnapshot) = await _loadStores(
          limit: 10,
          lastDocument: lastDocument,
          filterOptions: state.filterOptions,
        );

        lastDocument = documentSnapshot;
        isLastPage = storeList.length < 10;

        List<Store> newStoreList = [...state.storeList, ...storeList];

        emit(state.copyWith(
          storeList: newStoreList,
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

  Future<void> _onApplyFilter(ApplyFilter event, Emitter<StoreState> emit) async {
    try {
      // 필터가 변경되면 상태를 초기화
      lastDocument = null;
      isLastPage = false;

      emit(state.copyWith(
        storeList: [],
        isLoading: true,
        filterOptions: event.filterOptions,
        isFiltered: event.filterOptions.hasFilter,
      ));

      final (storeList, documentSnapshot) = await _loadStores(
        limit: 10,
        filterOptions: event.filterOptions,
      );

      lastDocument = documentSnapshot;
      isLastPage = storeList.length < 10;

      emit(state.copyWith(
        storeList: storeList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        storeList: [],
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onResetFilter(ResetFilter event, Emitter<StoreState> emit) async {
    // 필터 리셋하고 초기 상태로 돌아감
    add(ApplyFilter(const FilterOptions()));
  }

  // 매장 목록 로드 메서드 (필터 옵션 적용)
  Future<(List<Store>, DocumentSnapshot?)> _loadStores({
    required int limit,
    DocumentSnapshot? lastDocument,
    required FilterOptions filterOptions,
  }) async {
    return fireStoreManager.getStoreList(
      limit: limit,
      lastDocument: lastDocument,
      cityId: filterOptions.cityId,
      districtId: filterOptions.districtId,
      categories: filterOptions.categories,
    );
  }
}