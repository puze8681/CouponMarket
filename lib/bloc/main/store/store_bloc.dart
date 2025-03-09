import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/model/store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StoreEvent {}
class InitStore extends StoreEvent {}
class LoadMoreStore extends StoreEvent {}
class StoreState {
  List<Store> storeList;
  bool isLoading;
  String? message;
  StoreState(this.storeList, {this.isLoading = false, this.message});
}

class StoreBloc extends Bloc<StoreEvent, StoreState> {

  StoreBloc() : super(StoreState([])){
    on<InitStore>(_onInit);
    on<LoadMoreStore>(_onLoadMore);
  }

  DocumentSnapshot? lastDocument;
  bool isLastPage = false;
  _onInit(InitStore event, Emitter<StoreState> emit) async {
    try {
      emit(StoreState([], isLoading: true));
      final (storeList, documentSnapshot) = await fireStoreManager.getStoreList(10, null);
      lastDocument = documentSnapshot;
      isLastPage = storeList.length < 10;
      emit(StoreState(storeList));
    } catch (e) {
      emit(StoreState([], message: e.toString()));
    }
  }

  bool isLoadEnable = true;
  _onLoadMore(LoadMoreStore event, Emitter<StoreState> emit) async {
    if(isLoadEnable && !isLastPage){
      isLoadEnable = false;
      try {
        emit(StoreState(state.storeList, isLoading: true));
        final (storeList, documentSnapshot) = await fireStoreManager.getStoreList(10, lastDocument);
        lastDocument = documentSnapshot;
        isLastPage = storeList.length < 10;
        List<Store> newStoreList = [...state.storeList, ...storeList];
        emit(StoreState(newStoreList));
      } catch (e) {
        emit(StoreState(state.storeList, message: e.toString()));
      }
      isLoadEnable = true;
    }
  }
}