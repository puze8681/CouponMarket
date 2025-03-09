import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}
class InitHome extends HomeEvent {}
class HomeState {
  List<Store> storeList;
  bool isLoading;
  String? message;
  HomeState(this.storeList, {this.isLoading = false, this.message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState([])){
    on<InitHome>(_onInit);
  }

  _onInit(InitHome event, Emitter<HomeState> emit) async {
    final (storeList, _) = await fireStoreManager.getStoreList(2, null);
    emit(HomeState(storeList));
  }
}