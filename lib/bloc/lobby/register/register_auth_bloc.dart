import 'dart:developer';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RegisterAuthEvent {}
class DoRegisterAuth extends RegisterAuthEvent {
  String email;
  String password;
  DoRegisterAuth(this.email, this.password);
}
class ResetRegisterAuth extends RegisterAuthEvent {}
class VerifyRegisterAuth extends RegisterAuthEvent {}

class RegisterAuthState {
  String status;
  String? message;
  String? provider;
  bool isLoading;
  RegisterAuthState({required this.status, this.message, this.provider, this.isLoading = false});

  RegisterAuthState copyWith({String? status, String? message, String? provider, bool? isLoading}){
    return RegisterAuthState(
      status: status ?? this.status,
      message: message,
      provider: provider,
      isLoading: isLoading ?? false,
    );
  }
}

class RegisterAuthBloc extends Bloc<RegisterAuthEvent, RegisterAuthState> {
  RegisterAuthBloc() : super(RegisterAuthState(status: "YET")) {
    on<DoRegisterAuth>(_onDo);
    on<ResetRegisterAuth>(_onReset);
    on<VerifyRegisterAuth>(_onVerify);
  }

  _onDo(DoRegisterAuth event, Emitter<RegisterAuthState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      var credential = await firebaseManager.auth.signInWithEmailAndPassword(email: event.email, password: event.email);
      if(credential.user!.emailVerified){ // 메일 인증됨
        bool isUserExist = await fireStoreManager.getUserExist(event.email);
        if(isUserExist){ // 회원가입완료됨
          emit(state.copyWith(status: "EXIST"));
        }else{ // 정보입력필요함
        }
      }else{ // 메일 인증 안됨
        await credential.user!.sendEmailVerification();
        emit(state.copyWith(status: "SEND"));
      }
    } on FirebaseAuthException catch (e) {
      log("_onDo/FirebaseAuthException: ${e.code}/${e.credential?.signInMethod}/${e.credential?.providerId}/${e.plugin}/${e.message}/${e.tenantId}");
      if(e.code == "account-exists-with-different-credential"){
        emit(state.copyWith(provider: "ELSE"));
      }else if(e.code == "user-not-found"){
        try {
          var credential =await firebaseManager.auth.createUserWithEmailAndPassword(email: event.email, password: event.password);
          if (credential.user!.emailVerified) {
            emit(state.copyWith(status: "DONE"));
          } else {
            await credential.user!.sendEmailVerification();
            emit(state.copyWith(status: "SEND"));
          }
        } on FirebaseAuthException catch (e) {
          log("_onDo/FirebaseAuthException: ${e.code}/${e.credential?.signInMethod}/${e.credential?.providerId}/${e.plugin}/${e.message}/${e.tenantId}");
          emit(state.copyWith(message: e.toString()));
        } catch (e) {
          emit(state.copyWith(message: e.toString()));
        }
      }else{
        emit(state.copyWith(provider: "EMAIL"));
      }
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  _onReset(ResetRegisterAuth event, Emitter<RegisterAuthState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await firebaseManager.auth.currentUser?.delete();
      emit(state.copyWith(status: "YET"));
    } on FirebaseAuthException catch (e) {
      log("_onReset/FirebaseAuthException: ${e.code}/${e.credential?.signInMethod}/${e.credential?.providerId}/${e.plugin}/${e.message}/${e.tenantId}");
      emit(state.copyWith(message: e.toString()));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  _onVerify(VerifyRegisterAuth event, Emitter<RegisterAuthState> emit) async {
    try{
      emit(state.copyWith(isLoading: true));
      await firebaseManager.auth.currentUser?.reload();
      var isVerified = firebaseManager.auth.currentUser?.emailVerified ?? false;
      if(isVerified){
        emit(state.copyWith(status: "DONE"));
      }else{
        emit(state.copyWith(message: "verified yet"));
      }
    } on FirebaseAuthException catch (e) {
      log("_onVerify/FirebaseAuthException: ${e.code}/${e.credential?.signInMethod}/${e.credential?.providerId}/${e.plugin}/${e.message}/${e.tenantId}");
      emit(state.copyWith(message: e.toString()));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}