import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final bool enable;
  final double? height;
  final bool isExpanded;
  final Color backgroundColor;
  final Color textColor;

  const BasicButton(this.text, this.onClick, {super.key,
    this.enable = true,
    this.height = 56,
    this.isExpanded = false,
    this.backgroundColor = const Color(0xff498AFF),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick.call(),
      child: Container(
        decoration: BoxDecoration(
          color: enable ? backgroundColor : const Color(0xffD8E1F1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: isExpanded ? double.infinity : null,
        height: height,
        alignment: Alignment.center,
        child: BasicText(text, 16, 20, FontWeight.w600, textColor: textColor, textAlign: TextAlign.center),
      ),
    );
  }
}