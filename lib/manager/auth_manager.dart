import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/router/app_router.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

AuthService authManager = AuthManager();
abstract class AuthService {
  bool isLogIn();
  Future<void> setUser(User user);
  void setNumber(String number);
  User get user;
  String get number;
  Future<void> logOut(String message);
}

class AuthManager extends AuthService {
  User? mUser;
  String mNumber;
  AuthManager({this.mUser, this.mNumber = ""});

  @override
  bool isLogIn(){
    return mUser != null;
  }

  @override
  Future<void> setUser(User user) async {
    mUser = user;
    mNumber = await fireStoreManager.getUserNumber(user.uid);
  }

  @override
  void setNumber(String number) {
    mNumber = number;
  }

  @override
  User get user {
    if(mUser != null){
      return mUser!;
    }
    throw Exception("로그인이 필요합니다.");
  }

  @override
  String get number {
    return mNumber;
  }

  @override
  Future<void> logOut(String message) async {
    mUser = null;
    mNumber = "";
    String routeFrom = MyNavigatorObserver.routeStack.lastOrNull?.settings.name ?? "Unknown";
    Map<String, dynamic> arg = {"message": message, "from": routeFrom};
    Get.offAllNamed(routeLoginPage, arguments: arg);
  }
}