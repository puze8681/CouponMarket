import 'package:coupon_market/bloc/lobby/register/register_auth_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/register_provider_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterAuthPage extends StatefulWidget {
  const RegisterAuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterAuthPageState();
}

class _RegisterAuthPageState extends State<RegisterAuthPage> {
  final RegisterAuthBloc _bloc = RegisterAuthBloc();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool get isDoEnable {
    String email = emailController.text;
    String password = passwordController.text;
    String confirm = confirmController.text;
    return email.isEmail && password.isPassword && (confirm == password);
  }

  bool get isWrongPassword {
    String password = passwordController.text;
    return password.isNotEmpty && !password.isPassword;
  }

  bool get isIncorrectConfirm {
    String password = passwordController.text;
    String confirm = confirmController.text;
    return password.isPassword && password != confirm;
  }

  _onChangeText(String text){
    setState(() {});
  }

  _onClickDo() {
    String email = emailController.text;
    String password = passwordController.text;
    if(isDoEnable){
      _bloc.add(DoRegisterAuth(email, password));
    }
  }

  _onClickReset() {
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
    setState(() {});
    _bloc.add(ResetRegisterAuth());
  }

  _onClickVerify() {
    _bloc.add(VerifyRegisterAuth());
  }

  _onShowProvider(String provider){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return RegisterProviderModal(
          provider: provider,
          onClickLogin: _onClickLogin,
          onClickFindPassword: _onClickFindPassword,
        );
      },
    );
  }

  _onClickLogin(){
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  _onClickFindPassword(){
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushNamed(routeFindPasswordPage, arguments: {"email", emailController.text});
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

extension on _RegisterAuthPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, RegisterAuthState state) async {
        if(state.message != null){
          Fluttertoast.showToast(msg: state.message!);
        }else if(state.provider != null){
          _onShowProvider(state.provider!);
        }else if(state.status == "DONE"){
          Navigator.of(context).pushReplacementNamed(routeAuthInfoPage);
        }else if(state.status == "EXIST"){
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(routeMainPage);
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, RegisterAuthState state){
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
                              const SizedBox(height: 42),
                              inputWidget(state.status),
                              const Spacer(),
                              if(state.status == "SEND") nextButton,
                              const SizedBox(height: 34),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(state.isLoading) IndicatorWidget(),
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
    return const BasicText("Hello,\nResgister to get started!", 20, 24, FontWeight.w600, textColor: Color(0xff30333E));
  }

  Widget inputWidget(String status) {
    Widget button = status == "YET" ? registerButton : resetButton;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: inputBox("Enter your email", emailController, false)),
            const SizedBox(width: 8),
            button,
          ],
        ),
        if(status == "YET") Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            inputBox("Enter your password", passwordController, true),
            const SizedBox(height: 6),
            BasicText("Please enter 8 to 16 characters using a combination of at least 3 letters, numbers, and special characters.", 12, 14, FontWeight.w400, textColor: isWrongPassword ? const Color(0xffFA5800) : const Color(0xff30333E), textAlign: TextAlign.left),
            const SizedBox(height: 20),
            inputBox("Confirm your password", confirmController, true),
            const SizedBox(height: 6),
            if(isIncorrectConfirm) const BasicText("Password is incorrect.", 12, 14, FontWeight.w400, textColor: Color(0xffFA5800), textAlign: TextAlign.left),
          ],
        ),
        if(status != "YET") Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            BasicText("Please verify email with link and click next button", 12, 14, FontWeight.w400, textColor: isWrongPassword ? const Color(0xffFA5800) : const Color(0xff30333E), textAlign: TextAlign.left),
          ],
        ),
      ],
    );
  }
  
  Widget get registerButton {
    return BasicButton("Register", _onClickDo, enable: isDoEnable);
  }

  Widget get resetButton {
    return BasicButton("Reset", _onClickReset);
  }

  Widget get nextButton {
    return BasicButton("Next", _onClickVerify, isExpanded: true);
  }

  Widget inputBox(String hint, TextEditingController controller, bool isObscure){
    return BasicTextField(hint, controller, isObscure: isObscure, width: double.infinity, onChanged: _onChangeText);
  }
}