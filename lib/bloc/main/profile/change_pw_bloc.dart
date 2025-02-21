import 'dart:developer';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangePwEvent {}
class DoChangePw extends ChangePwEvent {
  String email;
  DoChangePw(this.email);
}
class ChangePwState {
  bool isLoading;
  String? message;
  ChangePwState({this.isLoading = false, this.message});
}

class ChangePwBloc extends Bloc<ChangePwEvent, ChangePwState> {
  ChangePwBloc() : super(ChangePwState()) {
    on<DoChangePw>(_onDo);
  }

  _onDo(DoChangePw event, Emitter<ChangePwState> emit) async {
    try {
      emit(ChangePwState(isLoading: true));
      await firebaseManager.auth.sendPasswordResetEmail(email: event.email);
      emit(ChangePwState(message: "password reset email has sent"));
    } catch (e) {
      emit(ChangePwState(message: e.toString()));
    }
  }
}