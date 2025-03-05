import 'dart:io';

import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}
class InitHome extends HomeEvent {}
class ImageHome extends HomeEvent {
  TestResult testResult;
  File image;
  ImageHome(this.testResult, this.image);
}
class HomeState {
  List<TestResult> testList;
  bool isLoading;
  String? message;
  HomeState(this.testList, {this.isLoading = false, this.message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState([])){
    on<InitHome>(_onInit);
    on<ImageHome>(_onImage);
  }

  _onInit(InitHome event, Emitter<HomeState> emit) async {
    final (testList, _) = await fireStoreManager.getTestResultList(2, null);
    emit(HomeState(testList));
  }

  _onImage(ImageHome event, Emitter<HomeState> emit) async {
    try {
      emit(HomeState(state.testList, isLoading: true));

      List<TestResult> resultList = state.testList;
      int index = resultList.indexWhere((e) => e.id == event.testResult.id);
      if(index >= 0){
        String imageUrl = await fireStoreManager.uploadImage(event.image);
        TestResult testResult = event.testResult.setImage(imageUrl);
        fireStoreManager.patchTestResult(testResult);
        resultList[index] = testResult;
        emit(HomeState(resultList));
      }else{
        emit(HomeState(state.testList, message: "Can not update image"));
      }
    } catch (e) {
      emit(HomeState(state.testList, message: e.toString()));
    }
  }
}