import 'dart:developer';

import 'package:coupon_market/constant/parameter_text.dart';
import 'package:coupon_market/constant/term_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

extension PaddingExtension on BuildContext {
  double get bottomPadding {
    var viewPadding = MediaQuery.of(this).viewPadding;

    return viewPadding.bottom;
  }

  double get topPadding {
    var viewPadding = MediaQuery.of(this).viewPadding;

    return viewPadding.top;
  }
}

extension IntTimerParsing on int {
  String parseTimer() {
    int minute = (this / 60).floor();
    int second = (this % 60);
    String minuteString = minute == 0 ? "" : "$minute분 ";
    String secondString = "$second초";
    return minuteString + secondString;
  }

  String parseHour() {
    if (this < 10) {
      return "0$this";
    } else {
      return "$this";
    }
  }

  String get timerText {
    int sec = this % 60;
    int min = (this / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }
}

extension DoubleMoneyParsing on double {
  String parseMoney() {
    return NumberFormat("#,##0").format(this);
  }

  String unitValue(double minUnit, bool isLeftBracket, bool isRightBracket) {
    if (this == 0) {
      if (minUnit >= 1) return '0';
      if (minUnit >= 0.1) return '0.0';
      return '0.00';
    }

    int decimalPlaces = 0;
    double temp = minUnit;
    while (temp < 1) {
      decimalPlaces++;
      temp *= 10;
    }

    var text = toStringAsFixed(decimalPlaces);
    if(isLeftBracket) return ">$text";
    if(isRightBracket) return "<$text";
    return text;
  }

  String get formatNumber {
    return (this % 1 == 0) ? toInt().toString() : toString();
  }
}

extension TypoExtension on TextStyle {
  TextStyle colored(Color color) {
    return copyWith(color: color);
  }
}

extension FormattedDateTime on DateTime {
  String format(String format) {
    return DateFormat(format).format(this);
  }
}

extension TermString on String {
  String get termTitle {
    switch(this){
      case "TOS" : return "[필수] 서비스 이용 약관 동의";
      case "PRIVACY" : return "[필수] 개인 정보 이용 약관 동의";
      case "MARKETING" : return "[필수] 마케팅 활용 동의";
      default: return "";
    }
  }

  String get termName {
    switch(this){
      case "TOS" : return "서비스 이용";
      case "PRIVACY" : return "개인 정보 이용";
      case "MARKETING" : return "마케팅 활용";
      default: return "";
    }
  }

  String get termContent {
    switch(this){
      case "TOS" : return TermsText.tosText;
      case "PRIVACY" : return TermsText.privacyText;
      case "MARKETING" : return TermsText.marketingText;
      default: return "";
    }
  }
}

extension ValidString on String {
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isPassword {
    // 길이 검사 (8-16자)
    if (length < 8 || length > 16) {
      return false;
    }

    // 각 문자 유형별 정규식
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(this);
    final hasDigit = RegExp(r'\d').hasMatch(this);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);

    // 문자 유형 카운트 (문자, 숫자, 특수문자)
    int typeCount = 0;
    if (hasLetter) typeCount++;
    if (hasDigit) typeCount++;
    if (hasSpecial) typeCount++;

    // 3가지 유형 이상 조합 확인
    return typeCount >= 3;
  }
}

extension ColorFromString on String {
  Color toColor() {
    if (isEmpty) {
      return Colors.white;
    } else {
      var hexColor = replaceAll("#", "");
      if (hexColor.length == 3) {
        hexColor = "FF${hexColor[0]}${hexColor[0]}${hexColor[1]}${hexColor[1]}${hexColor[2]}${hexColor[2]}";
      }

      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }

      if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      }
    }
    return Colors.white;
  }
}

extension StringToDateTime on String {
  DateTime get dateTime {
    return DateFormat("hh:mm:ss").parse(this);
  }
}

extension SuperString on String? {
  bool get isNullOrEmpty {
    if(this != null){
      return this!.isEmpty;
    }else{
      return true;
    }
  }

  bool get isExist {
    return this != null && this!.isNotEmpty;
  }

  bool get isPhoneNumber {
    if(isExist) {
      return RegExp(r'^[0-9-]+$').hasMatch(this!);
    } else {
      return false;
    }
  }

  double get doubleValue {
    if (this!.startsWith('<')) {
      return double.parse(this!.substring(1));
    } else if (this!.startsWith('>')) {
      return double.parse(this!.substring(1));
    } else {
      return double.parse(this!);
    }
  }
}

extension IntExtension on int {
  String get resultText {
    switch(this){
      case 0: return "Good";
      case 1: return "Caution";
      case 2: return "Warning";
      default: return "Critical";
    }
  }

  Color get resultBackgroundColor {
    switch(this){
      case 0: return const Color(0xffECF0FF);
      case 1: return const Color(0xffAEDCFF);
      case 2: return const Color(0xff98ACBA);
      default: return const Color(0xff898989);
    }
  }

  Color get resultTextColor {
    switch(this){
      case 0: return const Color(0xff5A7EFF);
      case 1: return const Color(0xff30333E);
      case 2: return const Color(0xffFFFFFF);
      default: return const Color(0xffFFFFFF);
    }
  }

  double get measureUnit {
    switch(this){
      case 0: return 0.1;
      case 1: return 1;
      case 2: return 1;
      case 3: return 1;
      case 4: return 0.1;
      case 5: return 0.1;
      case 6: return 1;
      case 7: return 0.05;
      case 8: return 0.1;
      case 9: return 0.1;
      case 10: return 1;
      case 11: return 1;
      case 12: return 1;
      case 13: return 1;
      case 14: return 1;
      case 15: return 0.1;
      default: return 1;
    }
  }
}
extension DoubleExtension on double {
  Color resultColor(int material) {
    switch(level(material)){
      case 0: return const Color(0xff5A7EFF);
      case 1: return const Color(0xff54B5FF);
      case 2: return const Color(0xff98ACBA);
      default: return const Color(0xff818181);
    }
  }

  String resultText(int material) {
    switch(level(material)){
      case 0: return "Good";
      case 1: return "Caution";
      case 2: return "Warning";
      default: return "Critical";
    }
  }

  int level(int material) {
    switch (material) {
      case 0: // pH
        if (this >= 6.5 && this <= 8.5) return 0;
        if ((this > 5.9 && this <= 6.4) || (this > 8.5 && this <= 9.0)) return 1;
        if ((this > 5.4 && this <= 5.9) || (this > 9.0 && this <= 9.5)) return 2;
        return 3;

      case 1: // Hardness
        if (this >= 0 && this <= 120.0) return 0;
        if (this > 120.0 && this <= 180.0) return 1;
        if (this > 180.0 && this <= 250.0) return 2;
        return 3;

      case 2: // Total Alkalinity
        if (this >= 0.0 && this <= 120.0) return 0;
        if ((this > 59.0 && this <= 39.0) || (this > 120.0 && this <= 140.0)) return 1;
        if ((this > 39.0 && this <= 59.0) || (this > 140.0 && this <= 180.0)) return 2;
        return 3;

      case 3: // Lead
        if (this >= 0.0 && this <= 5.0) return 0;
        if (this > 5.0 && this <= 10.0) return 1;
        if (this > 10.0 && this <= 15.0) return 2;
        return 3;

      case 4: // Iron
        if (this >= 0.0 && this <= 0.3) return 0;
        if (this > 0.3 && this <= 0.5) return 1;
        if (this > 0.5 && this <= 1.0) return 2;
        return 3;

      case 5: // Copper
        if (this >= 0.0 && this <= 1.0) return 0;
        if (this > 1.0 && this <= 1.3) return 1;
        if (this > 1.3 && this <= 2.0) return 2;
        return 3;

      case 6: // Fluoride
        if (this >= 0.0 && this <= 0.7) return 0;
        if (this > 0.7 && this <= 1.5) return 1;
        if (this > 1.5 && this <= 2.0) return 2;
        return 3;

      case 7: // Manganese
        if (this >= 0.0 && this <= 0.05) return 0;
        if (this > 0.05 && this <= 0.1) return 1;
        if (this > 0.1 && this <= 0.3) return 2;
        return 3;

      case 8: // Total Chlorine
        if (this >= 0.0 && this <= 0.5) return 0;
        if (this > 0.5 && this <= 1.0) return 1;
        if (this > 1.0 && this <= 4.0) return 2;
        return 3;

      case 9: // Free Chlorine
        if (this >= 0.0 && this <= 0.5) return 0;
        if (this > 0.5 && this <= 1.0) return 1;
        if (this > 1.0 && this <= 4.0) return 2;
        return 3;

      case 10: // Nitrate
        if (this >= 0.0 && this <= 10.0) return 0;
        if (this > 10.0 && this <= 20.0) return 1;
        if (this > 20.0 && this <= 30.0) return 2;
        return 3;

      case 11: // Nitrite
        if (this >= 0.0 && this <= 1.0) return 0;
        if (this > 1.0 && this <= 2.0) return 1;
        if (this > 2.0 && this <= 3.0) return 2;
        return 3;

      case 12: // Sulfate
        if (this >= 0.0 && this <= 250.0) return 0;
        if (this > 250.0 && this <= 350.0) return 1;
        if (this > 350.0 && this <= 500.0) return 2;
        return 3;

      case 13: // Zinc
        if (this >= 0.0 && this <= 5.0) return 0;
        if (this > 5.0 && this <= 10.0) return 1;
        if (this > 10.0 && this <= 15.0) return 2;
        return 3;

      case 14: // Sodium Chloride
        if (this >= 0.0 && this <= 200.0) return 0;
        if (this > 200.0 && this <= 300.0) return 1;
        if (this > 300.0 && this <= 400.0) return 2;
        return 3;

      case 15: // Hydrogen Sulfide
        if (this >= 0.0 && this <= 0.05) return 0;
        if (this > 0.05 && this <= 0.1) return 1;
        if (this > 0.1 && this <= 0.5) return 2;
        return 3;

      default:
        return 0;
    }
  }
}

extension ParameterString on int {
  String get parameterDetail {
    switch(this){
      case 0: return "pH\n\n${ParametersText.phText}";
      case 1: return "Hardness\n\n${ParametersText.hardnessText}";
      case 2: return "Total Alkalinity\n\n${ParametersText.totalAlkalinityText}";
      case 3: return "Sodium Chloride\n\n${ParametersText.sodiumChlorideText}";
      case 4: return "Lead\n\n${ParametersText.leadText}";
      case 5: return "Iron\n\n${ParametersText.ironText}";
      case 6: return "Copper\n\n${ParametersText.copperText}";
      case 7: return "Manganese\n\n${ParametersText.manganeseText}";
      case 8: return "Total Chlorine\n\n${ParametersText.totalChlorineText}";
      case 9: return "Free Chlorine\n\n${ParametersText.freeChlorineText}";
      case 10: return "Nitrate\n\n${ParametersText.nitrateText}";
      case 11: return "Nitrites\n\n${ParametersText.nitritesText}";
      case 12: return "Hydrogen Sulfide\n\n${ParametersText.hydrogenSulfideText}";
      case 13: return "Sulfate\n\n${ParametersText.sulfateText}";
      case 14: return "Zinc\n\n${ParametersText.zincText}";
      case 15: return "Fluoride\n\n${ParametersText.fluorideText}";
      default: return [
        "pH",
        ParametersText.phText,
        "Hardness",
        ParametersText.hardnessText,
        "Total Alkalinity",
        ParametersText.totalAlkalinityText,
        "Sodium Chloride",
        ParametersText.sodiumChlorideText,
        "Lead",
        ParametersText.leadText,
        "Iron",
        ParametersText.ironText,
        "Copper",
        ParametersText.copperText,
        "Manganese",
        ParametersText.manganeseText,
        "Total Chlorine",
        ParametersText.totalChlorineText,
        "Free Chlorine",
        ParametersText.freeChlorineText,
        "Nitrate",
        ParametersText.nitrateText,
        "Nitrites",
        ParametersText.nitritesText,
        "Hydrogen Sulfide",
        ParametersText.hydrogenSulfideText,
        "Sulfate",
        ParametersText.sulfateText,
        "Zinc",
        ParametersText.zincText,
        "Fluoride",
        ParametersText.fluorideText,
      ].join("\n\n");
    }
  }
}
extension LastString on String {
  String lastChars(int n) => substring(length - n);
}

String get currentDay {
  return DateTime.now().format("yyyy-MM-dd");
}

String get currentDayBeforeWeek {
  return DateTime.now().add(const Duration(days: -6)).format("yyyyMMdd");
}

String get currentDayBeforeMonth {
  return DateTime.now().add(const Duration(days: -30)).format("yyyyMMdd");
}

String get currentDate {
  return DateTime.now().format("yyyyMMddHHmmss");
}

String get currentDateMinute {
  return DateTime.now().format("yyyyMMddHHmm");
}

String get currentTime {
  return DateFormat('HH:mm').format(DateTime.now());
}

String get today {
  return DateTime.now().format("yyyyMMdd");
}

String get todayString {
  return DateTime.now().format("yyyy년 MM월 dd일");
}

String get todayPrinterString {
  return DateTime.now().format("yyyy년 MM월 dd일 HH:mm:ss");
}

extension BoolFromDateTime on DateTime {
  bool get isToday {
    String date = format("yyyyMMdd");
    String today = DateTime.now().format("yyyyMMdd");
    return date == today;
  }
}

MethodChannel get channel => const MethodChannel('kr.puze.coupon_market');