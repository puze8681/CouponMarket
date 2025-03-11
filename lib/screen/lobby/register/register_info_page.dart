import 'package:coupon_market/bloc/lobby/register/register_info_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/text_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterInfoPage extends StatefulWidget {
  const RegisterInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterInfoPageState();
}

class _RegisterInfoPageState extends State<RegisterInfoPage> {
  final RegisterInfoBloc _bloc = RegisterInfoBloc();

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
      _bloc.add(DoRegisterInfo(name, number));
    }
  }

  _onShowDone(){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return TextModal(
          text: "회원가입이 완료되었습니다!",
          buttonText: "확인",
          onClick: _onClickDone,
        );
      },
    );
  }

  _onClickDone(){
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed(routeMainPage);
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

extension on _RegisterInfoPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, RegisterInfoState state) async {
        if(state.message != null){
          Fluttertoast.showToast(msg: state.message!);
        }else if(state.isDone){
          _onShowDone();
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, RegisterInfoState state){
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
                              titleWidget,
                              const SizedBox(height: 30),
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
    return const Navigation("");
  }

  Widget get titleWidget {
    return const BasicText("정보를\n입력해주세요", 20, 24, FontWeight.w600, textColor: Color(0xff30333E));
  }

  Widget get inputWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputBox("이름을 입력해주세요", nameController, false),
        const SizedBox(height: 20),
        inputBox("전화번호를 입력해주세요", numberController, false),
      ],
    );
  }

  Widget get doButton {
    return BasicButton("다음", _onClickDo, isExpanded: true, enable: isDoEnable);
  }

  Widget inputBox(String hint, TextEditingController controller, bool isObscure){
    return BasicTextField(hint, controller, isObscure: isObscure, width: double.infinity, onChanged: _onChangeText);
  }
}