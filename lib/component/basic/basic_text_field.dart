import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool enabled;
  final bool autoFocus;
  final bool isObscure;
  final TextInputType keyboardType;
  final double? width;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function? onError;
  final List<TextInputFormatter>? inputFormatterList;

  @override
  _BasicTextFieldState createState() => _BasicTextFieldState();

  const BasicTextField(this.hintText, this.controller, {
    super.key,
    this.enabled = true,
    this.autoFocus = false,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.width,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onError,
    this.inputFormatterList,
  });
}

class _BasicTextFieldState extends State<BasicTextField> {
  late bool _isObscure;
  late TextEditingController _textEditingController;
  late InputDecoration _decoration;

  @override
  void initState() {
    _isObscure = widget.isObscure;
    _textEditingController = widget.controller;
    _decoration = const InputDecoration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle typo = Typo.textFieldTypo;
    _decoration = InputDecoration(
      hintText: widget.hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
      filled: true,
      fillColor: Colors.transparent,
      border: InputBorder.none,
      hintStyle: typo.copyWith(color: const Color(0xff8391A1)),
    );

    if(widget.isObscure){
      _decoration = _decoration.copyWith(suffixIcon: _passwordSuffix);
    }

    return Container(
      alignment: Alignment.center,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: const Color(0xffE8ECF4)),
      ),
      child: TextField(
        inputFormatters: widget.inputFormatterList,
        onChanged: (text) {
          widget.onChanged?.call(text);
        },
        cursorColor: AppColors.black,
        textAlignVertical: widget.isObscure ? TextAlignVertical.center : TextAlignVertical.top,
        enabled: widget.enabled,
        style: typo,
        obscureText: _isObscure,
        keyboardType: widget.keyboardType,
        controller: _textEditingController,
        autofocus: widget.autoFocus,
        textInputAction: widget.textInputAction,
        decoration: _decoration,
      ),
    );
  }

  Widget get _passwordSuffix {
    return SizedBox(
        child: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: (!_isObscure
              ? const Icon(
            Icons.remove_red_eye,
            size: 24,
            color: Color(0xff6A707C),
          )
              : const SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              Icons.remove_circle_outline,
              size: 24,
              color: Color(0xff6A707C),
            ),
          )),
        ));
  }
}
