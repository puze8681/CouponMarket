import 'dart:io';

import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:flutter/material.dart';

class DeleteTypeModal extends StatelessWidget {
  final Function(int) onClickType;

  const DeleteTypeModal({
    super.key,
    required this.onClickType,
  });

  _onClickType(int type){
    onClickType.call(type);
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BasicText("Please select a provider\nto delete account", 16, 20, FontWeight.w400, textColor: Color(0xff000000), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Row(
            children: [
              emailButton,
              const SizedBox(width: 6),
              typeButton(1, Assets.ic_login_facebook),
              const SizedBox(width: 6),
              typeButton(2, Assets.ic_login_google),
              if(Platform.isIOS) const SizedBox(width: 6),
              if(Platform.isIOS) typeButton(3, Assets.ic_login_facebook),
            ],
          )
        ],
      ),
    );
  }

  Widget get emailButton {
    return Expanded(
      child: GestureDetector(
        onTap: ()=> _onClickType(0),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(8)
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.email_rounded, size: 26),
        ),
      ),
    );
  }

  Widget typeButton(int type, String asset){
    return Expanded(
      child: GestureDetector(
        onTap: ()=> _onClickType(type),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(8)
          ),
          alignment: Alignment.center,
          child: AssetWidget(asset, width: 26, height: 26),
        ),
      ),
    );
  }
}