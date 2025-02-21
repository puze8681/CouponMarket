import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  final String text;
  final bool isBackButton;
  final Widget? rightButton;

  const Navigation(this.text, {super.key, this.isBackButton = true, this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: BasicText(text, 16, 20, FontWeight.w500),
          ),
          if(isBackButton) Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
                child: const AssetWidget(Assets.ic_navigation_left, width: 24, height: 24),
              ),
            ),
          ),
          if(rightButton != null) Align(
            alignment: Alignment.centerLeft,
            child: rightButton,
          ),
        ],
      ),
    );
  }
}