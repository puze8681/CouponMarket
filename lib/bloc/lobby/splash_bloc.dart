import 'dart:developer';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/manager/permission_manager.dart';
import 'package:coupon_market/manager/push_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SplashEvent {}
class InitSplash extends SplashEvent {}

abstract class SplashState {}
class SplashInitYet extends SplashState {}
class SplashNeedLogin extends SplashState {
  String? message;
  SplashNeedLogin(this.message);
}
class SplashDone extends SplashState {}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  String permissionMessage = '권한 설정에 실패했습니다.';
  String pushMessage = '알림 설정에 실패했습니다.';
  String loginMessage = '자동 로그인을 할 수 없습니다.';
  String userMessage = '유저 정보를 불러올 수 없습니다.';

  SplashBloc() : super(SplashInitYet()) {
    on<InitSplash>(_onInitSplash);
  }

  _onInitSplash(InitSplash event, Emitter<SplashState> emit) async {
    try{
      await firebaseManager.init();
      await permissionManager.init();
      await pushManager.init();
      var user = firebaseManager.auth.currentUser;
      if(user != null){
        bool isUserExist = await fireStoreManager.isUserExist(user.uid);
        log("_onDo/isUserExist: $isUserExist");
        if(isUserExist){
          authManager.setUser(user);
          emit(SplashDone());
        }else{
          emit(SplashNeedLogin(null));
        }
      }else{
        emit(SplashNeedLogin(null));
      }
    }catch(e){
      emit(SplashNeedLogin(e.toString()));
    }
  }
}