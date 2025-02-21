import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class ImageModal extends StatelessWidget {
  final Function onClickCamera;
  final Function onClickGallery;

  const ImageModal({
    super.key,
    required this.onClickCamera,
    required this.onClickGallery,
  });

  @override
  Widget build(BuildContext context) {

    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BasicText("Please select a method\nto add an image", 16, 20, FontWeight.w400, textColor: Color(0xff000000), textAlign: TextAlign.center),
          const SizedBox(height: 24),
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
      child: GestureDetector(
        onTap: ()=>onClickCamera.call(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const BasicText("Camera", 16, 20, FontWeight.w500, textColor: AppColors.primary),
        ),
      ),
    );
  }

  Widget get positiveButton {
    return Expanded(
      child: GestureDetector(
        onTap: ()=>onClickGallery.call(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 35),
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const BasicText("Gallery", 16, 20, FontWeight.w500, textColor: Colors.white),
        ),
      ),
    );
  }
}