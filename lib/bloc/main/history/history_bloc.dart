import 'dart:io';

import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/test_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HistoryEvent {}
class InitHistory extends HistoryEvent {}
class LoadMoreHistory extends HistoryEvent {}
class ImageHistory extends HistoryEvent {
  TestResult testResult;
  File image;
  ImageHistory(this.testResult, this.image);
}
class AddCategoryHistory extends HistoryEvent {
  String category;
  AddCategoryHistory(this.category);
}
class DeleteCategoryHistory extends HistoryEvent {
  String category;
  DeleteCategoryHistory(this.category);
}
class UpdateHistory extends HistoryEvent {
  String resultId;
  UpdateHistory(this.resultId);
}

class HistoryState {
  List<String> categoryList;
  List<TestResult> testList;
  bool isLoading;
  String? message;
  HistoryState(this.categoryList, this.testList, {this.isLoading = false, this.message});
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {

  HistoryBloc() : super(HistoryState([], [])){
    on<InitHistory>(_onInit);
    on<LoadMoreHistory>(_onLoadMore);
    on<ImageHistory>(_onImage);
    on<AddCategoryHistory>(_onAddCategory);
    on<DeleteCategoryHistory>(_onDeleteCategory);
    on<UpdateHistory>(_onUpdate);
  }

  DocumentSnapshot? lastDocument;
  bool isLastPage = false;
  _onInit(InitHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(HistoryState([], [], isLoading: true));
      List<String> categoryList = await fireStoreManager.getCategoryList();
      final (testList, documentSnapshot) = await fireStoreManager.getTestResultList(10, null);
      lastDocument = documentSnapshot;
      isLastPage = testList.length < 10;
      emit(HistoryState(categoryList, testList));
    } catch (e) {
      emit(HistoryState([], [], message: e.toString()));
    }
  }

  bool isLoadEnable = true;
  _onLoadMore(LoadMoreHistory event, Emitter<HistoryState> emit) async {
    if(isLoadEnable && !isLastPage){
      isLoadEnable = false;
      try {
        emit(HistoryState(state.categoryList, state.testList, isLoading: true));
        final (testList, documentSnapshot) = await fireStoreManager.getTestResultList(10, lastDocument);
        lastDocument = documentSnapshot;
        isLastPage = testList.length < 10;
        List<TestResult> newTestList = [...state.testList, ...testList];
        emit(HistoryState(state.categoryList, newTestList));
      } catch (e) {
        emit(HistoryState(state.categoryList, state.testList, message: e.toString()));
      }
      isLoadEnable = true;
    }
  }

  _onImage(ImageHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(HistoryState(state.categoryList, state.testList, isLoading: true));

      List<TestResult> resultList = state.testList;
      int index = resultList.indexWhere((e) => e.id == event.testResult.id);
      if(index >= 0){
        String imageUrl = await fireStoreManager.uploadImage(event.image);
        TestResult testResult = event.testResult.setImage(imageUrl);
        fireStoreManager.patchTestResult(testResult);
        resultList[index] = testResult;
        emit(HistoryState(state.categoryList, resultList));
      }else{
        emit(HistoryState(state.categoryList, state.testList, message: "Can not update image"));
      }
    } catch (e) {
      emit(HistoryState(state.categoryList, state.testList, message: e.toString()));
    }
  }

  _onAddCategory(AddCategoryHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(HistoryState(state.categoryList, state.testList, isLoading: true));
      if(state.categoryList.contains(event.category)){
        emit(HistoryState(state.categoryList, state.testList, message: "Already exist category"));
      }else if(state.categoryList.length >= 5){
        emit(HistoryState(state.categoryList, state.testList, message: "Category can add in 5"));
      }else{
        await fireStoreManager.addCategory(event.category);
        emit(HistoryState([...state.categoryList, event.category], state.testList));
      }
    } catch (e) {
      emit(HistoryState(state.categoryList, state.testList, message: e.toString()));
    }
  }

  _onDeleteCategory(DeleteCategoryHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(HistoryState(state.categoryList, state.testList, isLoading: true));
      String category = event.category;
      List<String> categoryList = state.categoryList;
      List<TestResult> testList = state.testList;
      if(categoryList.contains(category)){
        await fireStoreManager.deleteCategory(category);
        categoryList.remove(category);
      }
      if(testList.where((test) => test.category == category).isNotEmpty){
        await fireStoreManager.deleteTestResult(category);
        final (newTestList, documentSnapshot) = await fireStoreManager.getTestResultList(10, null);
        testList = newTestList;
        lastDocument = documentSnapshot;
        isLastPage = testList.length < 10;
      }
      emit(HistoryState(categoryList, testList));
    } catch (e) {
      emit(HistoryState(state.categoryList, state.testList, message: e.toString()));
    }
  }

  _onUpdate(UpdateHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(HistoryState(state.categoryList, state.testList, isLoading: true));

      List<TestResult> resultList = state.testList;
      int index = resultList.indexWhere((e) => e.id == event.resultId);
      if(index >= 0){
        var newResult = await fireStoreManager.getTestResult(event.resultId);
        if(newResult != null){
          resultList[index] = newResult;
          emit(HistoryState(state.categoryList, resultList));
        }
      }
    } catch (e) {
      emit(HistoryState(state.categoryList, state.testList, message: e.toString()));
    }
  }
}