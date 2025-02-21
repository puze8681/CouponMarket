import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class FindIdModal extends StatelessWidget {
  final String email;
  final Function onClickDone;

  const FindIdModal({
    super.key,
    required this.email,
    required this.onClickDone,
  });

  @override
  Widget build(BuildContext context) {

    return DefaultModal(
      canPop: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          const BasicText("Your ID:", 16, 20, FontWeight.w500, textColor: Color(0xff898989)),
          const SizedBox(height: 14),
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const BasicText("Your registration is complete!", 16, 20, FontWeight.w500, textColor: Color(0xff30333E)),
          ),
          const SizedBox(height: 24),
          doneButton,
        ],
      ),
    );
  }

  Widget get doneButton {
    return GestureDetector(
      onTap: ()=>onClickDone.call(),
      child: Container(
        height: 46,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const BasicText("Done", 16, 20, FontWeight.w500, textColor: Colors.white),
      ),
    );
  }
}