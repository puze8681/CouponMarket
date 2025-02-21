import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditInfoEvent {}
class DoEditInfo extends EditInfoEvent {
  String name;
  String number;
  DoEditInfo(this.name, this.number);
}
class EditInfoState {
  bool isLoading;
  bool isDone;
  String? message;
  EditInfoState({this.isLoading = false, this.isDone = false, this.message});
}

class EditInfoBloc extends Bloc<EditInfoEvent, EditInfoState> {
  EditInfoBloc() : super(EditInfoState()) {
    on<DoEditInfo>(_onDo);
  }

  _onDo(DoEditInfo event, Emitter<EditInfoState> emit) async {
    try {
      emit(EditInfoState(isLoading: true));
      var user = firebaseManager.auth.currentUser;
      if(user != null){
        await fireStoreManager.setUser(user.uid, user.email ?? "", event.name, event.number);
        await firebaseManager.auth.currentUser?.updateDisplayName(event.name);
        emit(EditInfoState(isDone: true));
      }else{
        emit(EditInfoState(message: "Can not change info\nQuit application and try again"));
      }
    } catch (e) {
      emit(EditInfoState(message: e.toString()));
    }
  }
}