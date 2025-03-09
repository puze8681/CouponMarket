import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/manager/auth_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class LoginEvent {}
class DoLogin extends LoginEvent {
  String email;
  String password;
  DoLogin(this.email, this.password);
}
class GoogleLogin extends LoginEvent {}
class AppleLogin extends LoginEvent {}

class LoginState {}
class LoginDefault extends LoginState {
  String? message;
  LoginDefault({this.message});
}
class LoginLoading extends LoginState {}
class LoginDone extends LoginState {
  bool infoExist;
  bool needAgree;
  LoginDone(this.infoExist, {this.needAgree = true});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginDefault()) {
    on<DoLogin>(_onDo);
    on<GoogleLogin>(_onGoogle);
    on<AppleLogin>(_onApple);
  }

  _onDo(DoLogin event, Emitter<LoginState> emit) async {
    try{
      emit(LoginLoading());
      var credential = await firebaseManager.auth.signInWithEmailAndPassword(email: event.email, password: event.password);
      var user = credential.user;
      if(user != null){
        authManager.setUser(user);
        bool isUserExist = await fireStoreManager.isUserExist(user.uid);
        emit(LoginDone(isUserExist, needAgree: false));
      }else{
        emit(LoginDefault());
      }
    } catch (e) {
      emit(LoginDefault(message: e.toString()));
    }
  }

  _onGoogle(GoogleLogin event, Emitter<LoginState> emit) async {
    try{
      emit(LoginLoading());
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication authentication = await account.authentication;
        OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken,
        );
        var credential = await firebaseManager.auth.signInWithCredential(oAuthCredential);
        var user = credential.user;
        if(user != null){
          authManager.setUser(user);
          bool isUserExist = await fireStoreManager.isUserExist(user.uid);
          emit(LoginDone(isUserExist));
        }
      }else{
        emit(LoginDefault());
      }
    } catch (e){
      emit(LoginDefault(message: e.toString()));
    }
  }

  _onApple(AppleLogin event, Emitter<LoginState> emit) async {
    try{
      emit(LoginLoading());
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      var credential = await firebaseManager.auth.signInWithCredential(oAuthCredential);
      var user = credential.user;
      if(user != null){
        authManager.setUser(user);
        bool isUserExist = await fireStoreManager.isUserExist(user.uid);
        emit(LoginDone(isUserExist));
      }else{
        emit(LoginDefault());
      }
    } catch (e){
      emit(LoginDefault(message: e.toString()));
    }
  }
}