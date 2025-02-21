import 'dart:developer';

import 'package:coupon_market/bloc/lobby/login_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBloc _bloc = LoginBloc();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _onClickFindId() => Navigator.of(context).pushNamed(routeFindIdPage);
  _onClickFindPassword() => Navigator.of(context).pushNamed(routeFindPasswordPage);
  _onClickLogin(){
    String email = emailController.text;
    String password = passwordController.text;
    bool emailEmpty = email.isEmpty;
    bool passwordEmpty = password.isEmpty;
    if(emailEmpty && passwordEmpty){
      Fluttertoast.showToast(msg: "Email and Password is empty");
    }else if(emailEmpty){
      Fluttertoast.showToast(msg: "Email is empty");
    }else if(passwordEmpty){
      Fluttertoast.showToast(msg: "Password is empty");
    }else{
      _bloc.add(DoLogin(email, password));
    }
  }
  _onClickFacebook() => _bloc.add(FacebookLogin());
  _onClickGoogle() => _bloc.add(GoogleLogin());
  _onClickApple() => _bloc.add(AppleLogin());
  _onClickSignUp() => Navigator.of(context).pushNamed(routeAuthTermPage, arguments: {"needRegister": true});

  bool _isLoading = false;
  setLoading(bool isLoading){
    setState(() {
      _isLoading = isLoading;
    });
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

extension on _LoginPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, LoginState state) async {
        log("login_page/state: ${state.runtimeType}");
        setLoading(state is LoginLoading);
        if(state is LoginDefault){
          if(state.message != null){
            String message = state.message!;
            if(message.contains("account-exists-with-different-credential")){
              message = "email used with another provider\nPlease try with right provider";
            }else if(message.contains("user-not-found")){
              message = "Not registered email\nPlease sign up";
            }else if(message.contains("wrong-password")){
              message = "Wrong password\nPlease enter right password";
            }
            Fluttertoast.showToast(msg: message);
          }
        }else if(state is LoginDone){
          if(state.infoExist){
            Navigator.of(context).pushReplacementNamed(routeMainPage);
          }else{
            if(state.needAgree){
              Navigator.of(context).pushNamed(routeAuthTermPage, arguments: {"needRegister": false});
            }else{
              Navigator.of(context).pushNamed(routeAuthInfoPage);
            }
          }
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    logoWidget,
                    const Spacer(flex: 1),
                    inputWidget,
                    const SizedBox(height: 12),
                    findWidget,
                    const SizedBox(height: 34),
                    loginButton,
                    const SizedBox(height: 14),
                    oAuthDivider,
                    const SizedBox(height: 24),
                    oAuthWidget,
                    const Spacer(flex: 4),
                    signUpWidget,
                    const SizedBox(height: 34),
                  ],
                ),
              ),
            ),
            if(_isLoading) const IndicatorWidget(),
          ],
        ),
      ),
    );
  }

  Widget get logoWidget {
    return const AssetWidget(Assets.ic_login_logo, width: 135, height: 34);
  }

  Widget get inputWidget {
    return Column(
      children: [
        inputBox("Enter your email", emailController, false),
        const SizedBox(height: 12),
        inputBox("Enter your password", passwordController, true),
      ],
    );
  }

  Widget inputBox(String hint, TextEditingController controller, bool isObscure){
    return BasicTextField(hint, controller, isObscure: isObscure, width: double.infinity);
  }

  Widget get findWidget {
    return Row(
      children: [
        const Spacer(),
        findButton("Find ID", _onClickFindId),
        const SizedBox(width: 8),
        Container(width: 1, height: 10, color: const Color(0xffC5C5C5)),
        const SizedBox(width: 8),
        findButton("Find Password", _onClickFindPassword),
      ],
    );
  }

  Widget findButton(String text, Function onClick){
    return GestureDetector(
      onTap: ()=>onClick.call(),
      child: Container(
        color: Colors.transparent,
        child: BasicText(text, 12, 14, FontWeight.w400, textColor: Color(0xff696D70)),
      ),
    );
  }

  Widget get loginButton {
    return BasicButton("Login", _onClickLogin, isExpanded: true);
  }

  Widget get oAuthDivider {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xffE8ECF4))),
        const SizedBox(width: 18),
        const BasicText("Or Login with", 12, 14, FontWeight.w400, textColor: Color(0xff696D70)),
        const SizedBox(width: 18),
        Expanded(child: Container(height: 1, color: const Color(0xffE8ECF4))),
      ],
    );
  }

  Widget get oAuthWidget {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        oAuthButton(Assets.ic_login_facebook, _onClickFacebook),
        const SizedBox(width: 6),
        oAuthButton(Assets.ic_login_google, _onClickGoogle),
        if(Platform.isIOS) const SizedBox(width: 6),
        if(Platform.isIOS) oAuthButton(Assets.ic_login_apple, _onClickApple),
      ],
    );
  }

  Widget oAuthButton(String asset, Function onClick){
    return Expanded(
      child: GestureDetector(
        onTap: ()=>onClick.call(),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffE8ECF4), width: 1),
            borderRadius: BorderRadius.circular(8)
          ),
          alignment: Alignment.center,
          child: AssetWidget(asset, width: 26, height: 26),
        ),
      ),
    );
  }

  Widget get signUpWidget {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BasicText("Don't have an account?", 14, 18, FontWeight.w500, textColor: Color(0xff696D70)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: _onClickSignUp,
          child: Container(
            color: Colors.transparent,
            child: BasicText("Sign up", 14, 18, FontWeight.w500, textColor: AppColors.primary),
          ),
        )
      ],
    );
  }
}