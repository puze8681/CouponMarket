import 'dart:developer';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FindPwEvent {}
class DoFindPw extends FindPwEvent {
  String email;
  DoFindPw(this.email);
}
class FindPwState {
  bool isLoading;
  String? message;
  FindPwState({this.isLoading = false, this.message});
}

class FindPwBloc extends Bloc<FindPwEvent, FindPwState> {
  FindPwBloc() : super(FindPwState()) {
    on<DoFindPw>(_onDo);
  }

  _onDo(DoFindPw event, Emitter<FindPwState> emit) async {
    try {
      emit(FindPwState(isLoading: true));
      await firebaseManager.auth.sendPasswordResetEmail(email: event.email);
      emit(FindPwState(message: "password reset email has sent"));
    } catch (e) {
      emit(FindPwState(message: e.toString()));
    }
  }
}