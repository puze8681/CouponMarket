import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class ProfilePasswordModal extends StatefulWidget {
  final Function(String) onEnterPassword;

  const ProfilePasswordModal({
    super.key,
    required this.onEnterPassword,
  });

  @override
  State<ProfilePasswordModal> createState() => _ProfilePasswordModalState();
}

class _ProfilePasswordModalState extends State<ProfilePasswordModal> {
  TextEditingController textEditingController = TextEditingController();

  bool get isEnterEnable => textEditingController.text.isPassword;

  _onChangeText(String text){
    setState(() {});
  }

  _onEnterPassword(){
    String passwordName = textEditingController.text;
    if(passwordName.isPassword){
      widget.onEnterPassword.call(passwordName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BasicTextField("Enter password", textEditingController, width: double.infinity, onChanged: _onChangeText),
          const SizedBox(height: 12),
          button,
        ],
      ),
    );
  }

  Widget get button {
    Color buttonColor = isEnterEnable ? AppColors.primary : const Color(0xffD8E1F1);
    return GestureDetector(
      onTap: _onEnterPassword,
      child: Container(
        width: double.infinity,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const BasicText("Enter", 16, 20, FontWeight.w500, textColor: Colors.white),
      ),
    );
  }
}