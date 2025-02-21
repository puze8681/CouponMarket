import 'package:coupon_market/bloc/lobby/find/find_id_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/find_id_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  State<StatefulWidget> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  final FindIdBloc _bloc = FindIdBloc();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  bool get isDoEnable {
    String name = nameController.text;
    String number = numberController.text;
    return name.isNotEmpty && number.isNotEmpty;
  }

  _onChangeText(String text){
    setState(() {});
  }

  _onClickDo() {
    String name = nameController.text;
    String number = numberController.text;
    if(isDoEnable){
      _bloc.add(DoFindId(name, number));
    }
  }

  _onShowEmail(String email){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return FindIdModal(
          email: email,
          onClickDone: _onClickDone,
        );
      },
    );
  }

  _onClickDone(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _FindIdPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, FindIdState state) async {
        if(state.message != null){
          Fluttertoast.showToast(msg: state.message!);
        }else if(state.email != null){
          _onShowEmail(state.email!);
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, FindIdState state){
          return SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      navigationWidget,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              inputWidget,
                              const SizedBox(height: 20),
                              doButton,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(state.isLoading) const IndicatorWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget get navigationWidget {
    return const Navigation("Find ID");
  }

  Widget get inputWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputBox("Please enter your name.", nameController, false),
        const SizedBox(height: 20),
        inputBox("01012345678", numberController, false),
      ],
    );
  }

  Widget get doButton {
    return BasicButton("Next", _onClickDo, isExpanded: true, enable: isDoEnable);
  }

  Widget inputBox(String hint, TextEditingController controller, bool isObscure){
    return BasicTextField(hint, controller, isObscure: isObscure, width: double.infinity, onChanged: _onChangeText);
  }
}