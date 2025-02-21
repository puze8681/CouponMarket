import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MainEvent {}

class MainState {}

class MainBloc extends Bloc<MainEvent, MainState> {

  MainBloc() : super(MainState());
}