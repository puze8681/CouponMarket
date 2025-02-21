import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class CategoryAddModal extends StatefulWidget {
  final Function(String) onClickAdd;

  const CategoryAddModal({
    super.key,
    required this.onClickAdd,
  });

  @override
  State<CategoryAddModal> createState() => _CategoryAddModalState();
}

class _CategoryAddModalState extends State<CategoryAddModal> {
  TextEditingController textEditingController = TextEditingController();

  bool get isAddEnable => textEditingController.text.isNotEmpty;

  _onChangeText(String text){
    setState(() {});
  }

  _onClickAdd(){
    String categoryName = textEditingController.text;
    if(categoryName.isNotEmpty){
      widget.onClickAdd.call(categoryName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BasicTextField("Enter new category name", textEditingController, width: double.infinity, onChanged: _onChangeText),
          const SizedBox(height: 12),
          button,
        ],
      ),
    );
  }

  Widget get button {
    Color buttonColor = isAddEnable ? AppColors.primary : const Color(0xffD8E1F1);
    return GestureDetector(
      onTap: _onClickAdd,
      child: Container(
        width: double.infinity,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const BasicText("Add", 16, 20, FontWeight.w500, textColor: Colors.white),
      ),
    );
  }
}