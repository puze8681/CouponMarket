import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RegisterInfoEvent {}
class DoRegisterInfo extends RegisterInfoEvent {
  String name;
  String number;
  DoRegisterInfo(this.name, this.number);
}
class RegisterInfoState {
  bool isLoading;
  bool isDone;
  String? message;
  RegisterInfoState({this.isLoading = false, this.isDone = false, this.message});
}

class RegisterInfoBloc extends Bloc<RegisterInfoEvent, RegisterInfoState> {
  RegisterInfoBloc() : super(RegisterInfoState()) {
    on<DoRegisterInfo>(_onDo);
  }

  _onDo(DoRegisterInfo event, Emitter<RegisterInfoState> emit) async {
    try {
      emit(RegisterInfoState(isLoading: true));
      var user = firebaseManager.auth.currentUser;
      if(user != null){
        await fireStoreManager.setUser(user.uid, user.email ?? "", event.name, event.number);
        await firebaseManager.auth.currentUser?.updateDisplayName(event.name);
        emit(RegisterInfoState(isDone: true));
      }else{
        emit(RegisterInfoState(message: "Quit application and try again"));
      }
    } catch (e) {
      emit(RegisterInfoState(message: e.toString()));
    }
  }
}