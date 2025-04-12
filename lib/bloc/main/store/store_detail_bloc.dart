import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 이벤트 정의
abstract class StoreDetailEvent {}
class UseStoreDetail extends StoreDetailEvent {
  Store store;
  UseStoreDetail(this.store);
}
class DownloadStoreDetail extends StoreDetailEvent {
  Store store;
  DownloadStoreDetail(this.store);
}

// 상태 정의
class StoreDetailState {
  final bool isLoading;
  final String? message;

  StoreDetailState({
    this.isLoading = false,
    this.message,
  });

  // 복사본 생성 메서드
  StoreDetailState copyWith({
    bool? isLoading,
    Store? store,
    String? message,
  }) {
    return StoreDetailState(
      isLoading: isLoading ?? false,
      message: message,
    );
  }
}

class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  StoreDetailBloc() : super(StoreDetailState(isLoading: false)) {
    on<UseStoreDetail>(_onUse);
    on<DownloadStoreDetail>(_onDownload);
  }

  Future<void> _onUse(UseStoreDetail event, Emitter<StoreDetailState> emit) async {
    String? result = await fireStoreManager.useCoupon(event.store);
    emit(state.copyWith(message: result));
  }
  Future<void> _onDownload(DownloadStoreDetail event, Emitter<StoreDetailState> emit) async {
    String? result = await fireStoreManager.downloadCoupon(event.store);
    emit(state.copyWith(message: result));
  }
}