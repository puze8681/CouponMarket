import 'package:coupon_market/bloc/main/profile/profile_bloc.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/delete_type_modal.dart';
import 'package:coupon_market/component/modal/profile_modal.dart';
import 'package:coupon_market/component/modal/profile_password_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/term_text.dart';
import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _bloc = ProfileBloc();

  _onClickLogout(){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ProfileModal(
          topText: "Are you sure you want to",
          bottomText: "log out?",
          onClickNegative: ()=>Navigator.of(context).pop(),
          onClickPositive: ()=>_bloc.add(LogoutProfile()),
        );
      },
    );
  }
  _onClickDelete(){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ProfileModal(
          topText: "Are you sure you want to",
          bottomText: "delete your account?",
          onClickNegative: ()=>Navigator.of(context).pop(),
          onClickPositive: () {
            Navigator.of(context).pop();
            _onSelectDeleteType();
          },
        );
      },
    );
  }

  _onSelectDeleteType(){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return DeleteTypeModal(
          onClickType: (type){
            Navigator.of(context).pop();
            if(type == 0){
              _onEnterPassword();
            }else{
              _bloc.add(DeleteProfile(type, null));
            }
          },
        );
      },
    );
  }

  _onEnterPassword(){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ProfilePasswordModal(
          onEnterPassword: (password) {
            Navigator.of(context).pop();
            _bloc.add(DeleteProfile(0, password));
          },
        );
      },
    );
  }

  _onClickRouteButton(String route, {Map<String, dynamic>? args}){
    Navigator.of(context).pushNamed(route, arguments: args);
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

extension on _ProfilePageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, ProfileState state) async {
        if(state.message != null){
          Fluttertoast.showToast(msg: state.message!);
        }else if(state.isQuit){
          Navigator.of(context).pushReplacementNamed(routeSplashPage);
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, ProfileState state){
          return SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      navigationWidget,
                      const SizedBox(height: 24),
                      infoWidget,
                      const SizedBox(height: 45),
                      divider,
                      buttonWidget("Edit My Information", routeEditInfoPage),
                      divider,
                      buttonWidget("Change Password", routeChangePwPage),
                      divider,
                      buttonWidget("Parameter Details", routeParameterDetail),
                      divider,
                      buttonWidget("Terms of Service", routeProfileTermPage, args: {
                        "title": "Terms of Service",
                        "content": TermsText.tosText,
                      }),
                      divider,
                      buttonWidget("Privacy Policy", routeProfileTermPage, args: {
                        "title": "Privacy Policy",
                        "content": TermsText.privacyText,
                      }),
                      const Spacer(),
                      deleteButton,
                      const SizedBox(height: 56),
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
    return const Navigation("Profile", isBackButton: false);
  }

  Widget get infoWidget {
    return Row(
      children: [
        const SizedBox(width: 26),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BasicText("Hello, ", 14, 16, FontWeight.w400, textColor: Color(0xff30333E)),
                  BasicText(firebaseManager.auth.currentUser?.displayName ?? "", 14, 18, FontWeight.w500, textColor: const Color(0xff30333E)),
                ],
              ),
              const SizedBox(height: 4),
              BasicText(firebaseManager.auth.currentUser?.email ?? "", 12, 14, FontWeight.w400, textColor: const Color(0xff898989)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _onClickLogout,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xffEFF4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const BasicText("Log out", 12, 14, FontWeight.w400, textColor: Color(0xff498AFF)),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget get divider => Container(width: double.infinity, height: 1, color: const Color(0xffEFF2F8));

  Widget buttonWidget(String title, String route, {Map<String, dynamic>? args}){
    return GestureDetector(
      onTap: ()=>_onClickRouteButton(route, args: args),
      child: Container(
        color: Colors.transparent,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.centerLeft,
        child: BasicText(title, 14, 16, FontWeight.w400, textColor: const Color(0xff30333E)),
      ),
    );
  }
  
  Widget get deleteButton {
    return GestureDetector(
      onTap: _onClickDelete, 
      child: Container(
       decoration: const BoxDecoration(
         color: Colors.transparent,
         border: Border(
           bottom: BorderSide( // POINT
             color: Color(0xff898989),
             width: 1,
           ),
         ),
       ),
       child: const BasicText("Delete account", 12, 15, FontWeight.w400, textColor: Color(0xff898989)),
     ),
    );
  }
}