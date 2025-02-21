import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class ProfileModal extends StatelessWidget {
  final String topText;
  final String bottomText;
  final Function onClickNegative;
  final Function onClickPositive;

  const ProfileModal({
    super.key,
    required this.topText,
    required this.bottomText,
    required this.onClickNegative,
    required this.onClickPositive,
  });

  @override
  Widget build(BuildContext context) {

    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 45),
          BasicText(topText, 16, 20, FontWeight.w400, textColor: const Color(0xff000000)),
          BasicText(bottomText, 16, 20, FontWeight.w600, textColor: const Color(0xff000000)),
          const SizedBox(height: 51),
          Row(
            children: [
              negativeButton,
              positiveButton,
            ],
          )
        ],
      ),
    );
  }

  Widget get negativeButton {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: ()=>onClickNegative.call(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const BasicText("No", 16, 20, FontWeight.w500, textColor: AppColors.primary),
        ),
      ),
    );
  }

  Widget get positiveButton {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: ()=>onClickPositive.call(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 35),
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const BasicText("Yes", 16, 20, FontWeight.w500, textColor: Colors.white),
        ),
      ),
    );
  }
}