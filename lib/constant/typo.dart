import 'package:flutter/cupertino.dart';
import 'package:coupon_market/constant/colors.dart';

class Typo {
  Typo._();

  static TextStyle typo = const TextStyle(
    fontFamily: "Pretendard",
    fontStyle: FontStyle.normal,
    height: 1,
    color: AppColors.mainText,
  );

  static TextStyle bold = typo.copyWith(fontWeight: FontWeight.w700);
  static TextStyle semiBold = typo.copyWith(fontWeight: FontWeight.w600);
  static TextStyle medium = typo.copyWith(fontWeight: FontWeight.w500);
  static TextStyle regular = typo.copyWith(fontWeight: FontWeight.w400);

  static TextStyle headline1 = semiBold.copyWith(fontSize: 30, height: 36/30);
  static TextStyle headline2 = semiBold.copyWith(fontSize: 24, height: 30/24);
  static TextStyle headline3 = semiBold.copyWith(fontSize: 22, height: 24/22);
  static TextStyle headline4 = semiBold.copyWith(fontSize: 20, height: 28/20);
  static TextStyle headline5 = bold.copyWith(fontSize: 18, height: 20/18);

  static TextStyle bodyXLarge = semiBold.copyWith(fontSize: 18, height: 22/18, letterSpacing: -(18 * 0.01));

  static TextStyle bodyLarge1 = semiBold.copyWith(fontSize: 16, height: 22/16, letterSpacing: -(16 * 0.01));
  static TextStyle bodyLarge2 = medium.copyWith(fontSize: 16, height: 18/16, letterSpacing: -(16 * 0.01));
  static TextStyle bodyLarge3 = regular.copyWith(fontSize: 16, height: 18/16, letterSpacing: -(16 * 0.01));
  
  static TextStyle bodyMedium1 = semiBold.copyWith(fontSize: 14, height: 20/14, letterSpacing: -(14 * 0.01));
  static TextStyle bodyMedium2 = medium.copyWith(fontSize: 14, height: 20/14, letterSpacing: -(14 * 0.01));
  static TextStyle bodyMedium3 = regular.copyWith(fontSize: 14, height: 16/14, letterSpacing: -(14 * 0.01));

  static TextStyle bodySmall = semiBold.copyWith(fontSize: 12, height: 12/12, letterSpacing: -(12 * 0.01));
  static TextStyle bodyXSmall = regular.copyWith(fontSize: 12, height: 12/12, letterSpacing: -(12 * 0.01));

  static TextStyle textFieldTypo = regular.copyWith(fontSize: 14, height: 16/14);
  static TextStyle buttonTypo = regular.copyWith(fontSize: 15, height: 20/15, color: AppColors.white);
}