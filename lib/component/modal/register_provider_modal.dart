import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class RegisterProviderModal extends StatelessWidget {
  final String provider;
  final Function onClickLogin;
  final Function onClickFindPassword;

  const RegisterProviderModal({
    super.key,
    required this.provider,
    required this.onClickLogin,
    required this.onClickFindPassword,
  });

  @override
  Widget build(BuildContext context) {

    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BasicText("This email is already registered", 16, 20, FontWeight.w500, textColor: Color(0xff30333E)),
          const SizedBox(height: 12),
           BasicText("Click the button below to log in.\nRegister provider is $provider", 12, 14, FontWeight.w400, textColor: Color(0xff696D70)),
          const SizedBox(height: 38),
          Row(
            children: [
              loginButton,
              if(provider == "EMAIL") findPasswordButton,
            ],
          )
        ],
      ),
    );
  }

  Widget get loginButton {
    return Expanded(
      child: GestureDetector(
        onTap: ()=>onClickLogin.call(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const BasicText("Log In", 16, 20, FontWeight.w500, textColor: AppColors.primary),
        ),
      ),
    );
  }

  Widget get findPasswordButton {
    return GestureDetector(
      onTap: ()=>onClickFindPassword.call(),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const BasicText("Find password", 16, 20, FontWeight.w500, textColor: Colors.white),
      ),
    );
  }
}