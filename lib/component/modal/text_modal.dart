import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class TextModal extends StatefulWidget {
  final String text;
  final String buttonText;
  final Function onClick;
  final bool canPop;

  const TextModal({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onClick,
    this.canPop = true,
  });

  @override
  State<TextModal> createState() => _TextModalState();
}

class _TextModalState extends State<TextModal> {
  @override
  Widget build(BuildContext context) {
    return DefaultModal(
      canPop: widget.canPop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 46),
          BasicText(widget.text, 16, 20, FontWeight.w500, textColor: Color(0xff30333E), textAlign: TextAlign.center),
          const SizedBox(height: 58),
          button,
        ],
      ),
    );
  }

  Widget get button {
    return GestureDetector(
      onTap: ()=>widget.onClick.call(),
      child: Container(
        width: double.infinity,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: BasicText(widget.buttonText, 16, 20, FontWeight.w500, textColor: Colors.white),
      ),
    );
  }
}