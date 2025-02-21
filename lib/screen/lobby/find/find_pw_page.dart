import 'package:coupon_market/bloc/lobby/find/find_pw_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/text_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FindPwPage extends StatefulWidget {
  const FindPwPage({super.key});

  @override
  State<StatefulWidget> createState() => _FindPwPageState();
}

class _FindPwPageState extends State<FindPwPage> {
  final FindPwBloc _bloc = FindPwBloc();

  final TextEditingController emailController = TextEditingController();

  bool get isDoEnable {
    String email = emailController.text;
    return email.isEmail;
  }

  _onChangeText(String text){
    setState(() {});
  }

  _onClickDo() {
    String email = emailController.text;
    if(isDoEnable){
      _bloc.add(DoFindPw(email));
    }
  }

  _onShowMessage(String message){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return TextModal(
          text: message,
          buttonText: "Done",
          onClick: _onClickDone,
          canPop: false,
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

extension on _FindPwPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, FindPwState state) async {
        if(state.message != null){
          _onShowMessage(state.message!);
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, FindPwState state){
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
    return const Navigation("Find Password");
  }

  Widget get inputWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputBox("Please enter your email.", emailController, false),
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