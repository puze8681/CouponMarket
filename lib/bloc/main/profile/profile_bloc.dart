import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class ProfileEvent {}
class LogoutProfile extends ProfileEvent {}
class DeleteProfile extends ProfileEvent {
  int type;
  String? password;
  DeleteProfile(this.type, this.password);
}
class ProfileState {
  bool isLoading;
  bool isQuit;
  String? message;
  ProfileState({this.isLoading = false, this.isQuit = false, this.message});
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<LogoutProfile>(_onLogout);
    on<DeleteProfile>(_onDelete);
  }

  _onLogout(LogoutProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileState(isLoading: true));
      await firebaseManager.auth.signOut();
      emit(ProfileState(isQuit: true));
    } catch (e) {
      emit(ProfileState(message: e.toString()));
    }
  }

  _onDelete(DeleteProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileState(isLoading: true));
      var user = firebaseManager.auth.currentUser;
      if(user != null){
        user.providerData;
        int type = event.type;
        AuthCredential? authCredential;
        if(type == 0 && event.password != null){
          authCredential = EmailAuthProvider.credential(email: user.email ?? "", password: event.password!);
        }else if(type == 1){
          LoginResult result = await FacebookAuth.instance.login();
          if(result.accessToken != null) {
            authCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
          }
        }else if(type == 2){
          GoogleSignIn googleSignIn = GoogleSignIn();
          GoogleSignInAccount? account = await googleSignIn.signIn();
          if (account != null) {
            GoogleSignInAuthentication authentication = await account.authentication;
            authCredential = GoogleAuthProvider.credential(
              idToken: authentication.idToken,
              accessToken: authentication.accessToken,
            );
          }
        }else if(type == 3){
          final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          authCredential = OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );
        }

        if(authCredential != null){
          await firebaseManager.auth.currentUser?.reauthenticateWithCredential(authCredential);
          await firebaseManager.auth.currentUser?.delete();
          await fireStoreManager.deleteUser();
          emit(ProfileState(isQuit: true));
        }else{
          emit(ProfileState());
        }
      }else{
        emit(ProfileState(isQuit: true, message: "유저를 찾을 수 없습니다."));
      }
    } catch (e) {
      emit(ProfileState(message: e.toString()));
    }
  }
}