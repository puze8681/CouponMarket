import 'package:coupon_market/bloc/main/profile/change_pw_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePwPage extends StatefulWidget {
  const ChangePwPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePwPageState();
}

class _ChangePwPageState extends State<ChangePwPage> {
  final ChangePwBloc _bloc = ChangePwBloc();

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
      _bloc.add(DoChangePw(email));
    }
  }

  _onShowMessage(String message){
    Fluttertoast.showToast(msg: message);
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

extension on _ChangePwPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, ChangePwState state) async {
        if(state.message != null){
          _onShowMessage(state.message!);
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, ChangePwState state){
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
                              const Spacer(),
                              doButton,
                              const SizedBox(height: 34),
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
    return const Navigation("비밀번호 변경");
  }

  Widget get inputWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputBox("이메일을 입력해주세요.", emailController, false),
      ],
    );
  }

  Widget inputBox(String hint, TextEditingController controller, bool isObscure){
    return BasicTextField(hint, controller, isObscure: isObscure, width: double.infinity, onChanged: _onChangeText);
  }

  Widget get doButton {
    return BasicButton("변경", _onClickDo, isExpanded: true, enable: isDoEnable);
  }
}