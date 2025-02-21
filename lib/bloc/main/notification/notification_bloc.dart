import 'dart:developer';

import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/notification_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationEvent {}
class LoadNotification extends NotificationEvent {}
class ReadNotification extends NotificationEvent {
  DateTime createdAt;
  ReadNotification(this.createdAt);
}

class NotificationState {
  List<NotificationData> notificationList;
  bool isLoading;
  String? message;
  NotificationState(this.notificationList, {this.isLoading = false, this.message});
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  NotificationBloc() : super(NotificationState([], isLoading: true)){
    on<LoadNotification>(_onLoad);
    on<ReadNotification>(_onRead);
  }

  DocumentSnapshot? lastDocument;
  bool isLastPage = false;
  bool isLoadEnable = true;
  _onLoad(LoadNotification event, Emitter<NotificationState> emit) async {
    if(isLoadEnable && !isLastPage){
      isLoadEnable = false;
      try {
        emit(NotificationState(state.notificationList, isLoading: true));
        final (notificationList, documentSnapshot) = await fireStoreManager.getNotificationList(20, lastDocument);
        lastDocument = documentSnapshot;
        isLastPage = notificationList.length < 20;
        List<NotificationData> newNotificationList = [...state.notificationList, ...notificationList];
        emit(NotificationState(newNotificationList));
      } catch (e) {
        emit(NotificationState(state.notificationList, message: e.toString()));
      }
      isLoadEnable = true;
    }
  }

  _onRead(ReadNotification event, Emitter<NotificationState> emit) async {
    try {
      log("_onRead/1");
      List<NotificationData> notificationList = state.notificationList;
      int index = notificationList.indexWhere((e) => e.createdAt.millisecondsSinceEpoch == event.createdAt.millisecondsSinceEpoch);
      log("_onRead/2: $index");
      if(index >= 0){
        log("_onRead/3: ${notificationList[index].toJson()}");
        NotificationData notificationData = notificationList[index].setRead();
        log("_onRead/4: ${notificationData.toJson()}");
        await fireStoreManager.patchNotification(notificationData);
        log("_onRead/5");
        notificationList[index] = notificationData;
        log("_onRead/6");
        emit(NotificationState(notificationList));
      }else{
        log("_onRead/7");
        emit(NotificationState(state.notificationList, message: "Cat not read notification"));
      }
    } catch (e) {
      log("_onRead/8: $e");
      emit(NotificationState(state.notificationList, message: e.toString()));
    }
  }
}