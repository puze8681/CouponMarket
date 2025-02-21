import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class CategoryDeleteModal extends StatefulWidget {
  final String category;
  final Function onClickDelete;

  const CategoryDeleteModal({
    super.key,
    required this.category,
    required this.onClickDelete,
  });

  @override
  State<CategoryDeleteModal> createState() => _CategoryDeleteModalState();
}

class _CategoryDeleteModalState extends State<CategoryDeleteModal> {
  @override
  Widget build(BuildContext context) {
    return DefaultModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 45),
          const BasicText("Are you sure you want to delete?", 16, 20, FontWeight.w400, textColor: Color(0xff000000)),
          BasicText("category name : ${widget.category}", 16, 20, FontWeight.w600, textColor: const Color(0xff000000)),
          const SizedBox(height: 51),
          button,
        ],
      ),
    );
  }

  Widget get button {
    return GestureDetector(
      onTap: () => widget.onClickDelete.call(),
      child: Container(
        width: double.infinity,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const BasicText("Delete", 16, 20, FontWeight.w500, textColor: Colors.white),
      ),
    );
  }
}