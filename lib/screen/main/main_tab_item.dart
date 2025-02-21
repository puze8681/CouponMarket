import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class MainTabItem extends StatelessWidget {
  final bool isActive;
  final String activeIcon;
  final String inactiveIcon;
  final String text;



  const MainTabItem({
    super.key,
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    Color activeColor = AppColors.mainScale1;
    Color inactiveColor = AppColors.tabInactive;
    Color color = isActive ? activeColor : inactiveColor;
    String icon = isActive ? activeIcon : inactiveIcon;
    return Container(
      margin: const EdgeInsets.only(left: 10),
      color: AppColors.transparent,
      height: 75 + context.bottomPadding,
      child: Column(children: <Widget>[
        const SizedBox(height: 10),
        AssetWidget(icon, height: 40, width: 40),
        Text(text, style: Typo.bodyMedium2.copyWith(color: color)),
      ]),
    );
  }
}