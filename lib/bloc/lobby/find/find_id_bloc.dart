import 'dart:developer';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FindIdEvent {}
class DoFindId extends FindIdEvent {
  String name;
  String number;
  DoFindId(this.name, this.number);
}
class FindIdState {
  bool isLoading;
  String? email;
  String? message;
  FindIdState({this.isLoading = false, this.email, this.message});
}

class FindIdBloc extends Bloc<FindIdEvent, FindIdState> {
  FindIdBloc() : super(FindIdState()) {
    on<DoFindId>(_onDo);
  }

  _onDo(DoFindId event, Emitter<FindIdState> emit) async {
    try {
      emit(FindIdState(isLoading: true));
      String? email = await fireStoreManager.getEmail(event.name, event.number);
      if(email != null){
        emit(FindIdState(email: email));
      }else{
        emit(FindIdState(message: "No such account exist"));
      }
    } catch (e) {
      emit(FindIdState(message: e.toString()));
    }
  }
}