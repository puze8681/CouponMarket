import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/coupon.dart';
import 'package:coupon_market/model/store.dart';
import 'package:coupon_market/util/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 이벤트 정의
abstract class CouponEvent {}
class InitCoupon extends CouponEvent {
  Coupon coupon;
  InitCoupon(this.coupon);
}
class UseCoupon extends CouponEvent {}
class DownloadCoupon extends CouponEvent {}
class SaveStoreCoupon extends CouponEvent {}

// 상태 정의
class CouponState {
  final bool isLoading;
  final Store? store;
  final bool isStoreSaved;
  final String? message;

  CouponState({
    this.isLoading = false,
    this.store,
    required this.isStoreSaved,
    this.message,
  });

  // 복사본 생성 메서드
  CouponState copyWith({
    bool? isLoading,
    Store? store,
    bool? isStoreSaved,
    String? message,
  }) {
    return CouponState(
      isLoading: isLoading ?? false,
      store: store ?? this.store,
      isStoreSaved: isStoreSaved ?? this.isStoreSaved,
      message: message,
    );
  }
}

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponState(isLoading: true, store: null, isStoreSaved: false)) {
    on<InitCoupon>(_onInit);
    on<UseCoupon>(_onUse);
    on<DownloadCoupon>(_onDownload);
    on<SaveStoreCoupon>(_onSave);
  }

  late Coupon coupon;
  Future<void> _onInit(InitCoupon event, Emitter<CouponState> emit) async {
    try {
      coupon = event.coupon;
      Store? store = await fireStoreManager.getStore(storeId: coupon.storeId);
      List<String> savedStoreIds = await localStorage.getSavedStoreIds();
      bool isSavedStore = savedStoreIds.contains(coupon.storeId);
      emit(state.copyWith(store: store, isStoreSaved: isSavedStore));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  Future<void> _onUse(UseCoupon event, Emitter<CouponState> emit) async {
    String? result = await fireStoreManager.useCoupon(coupon);
    emit(state.copyWith(message: result));
  }
  Future<void> _onDownload(DownloadCoupon event, Emitter<CouponState> emit) async {
    String? result = await fireStoreManager.downloadCoupon(coupon);
    emit(state.copyWith(message: result));
  }

  Future<void> _onSave(SaveStoreCoupon event, Emitter<CouponState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      bool isSavedStore = await localStorage.saveStoreId(coupon.storeId);
      emit(state.copyWith(isStoreSaved: isSavedStore));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}