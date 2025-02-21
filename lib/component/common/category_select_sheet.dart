import 'dart:developer';

import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class CategorySelectSheet extends StatefulWidget {
  final List<String> categoryList;
  final String? resultCategory;
  final Function(String) onClickDone;

  const CategorySelectSheet({super.key, required this.categoryList, required this.resultCategory, required this.onClickDone});

  @override
  State<CategorySelectSheet> createState() => _CategorySelectSheetState();
}

class _CategorySelectSheetState extends State<CategorySelectSheet> {

  _onClickDone(){
    if(selectedCategory != null){
      widget.onClickDone.call(selectedCategory!);
    }
  }

  String? selectedCategory;
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.resultCategory;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String category = widget.categoryList[index];
                        return categoryButton(category, selectedCategory, (){
                          setState(() {
                            if(selectedCategory == category){
                              selectedCategory = null;
                            }else{
                              selectedCategory = category;
                            }
                          });
                        });
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                      itemCount: widget.categoryList.length,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _onClickDone,
                child: Container(
                  color: AppColors.primary,
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text("Done", style: Typo.headline4.colored(AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget categoryButton(String category, String? selectedCategory, Function onClick){
    bool isSelected = category == selectedCategory;
    log("categoryButton/$category/$selectedCategory: $isSelected");
    BoxDecoration decoration = isSelected
        ? BoxDecoration(
      color: const Color(0xffEAF1FF),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(width: 1, color: AppColors.primary),
    ) : BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(width: 1, color: const Color(0xffBBCDDA)),
    );
    Color textColor = isSelected ? AppColors.primary : const Color(0xffBBCDDA);
    return GestureDetector(
      onTap: () => onClick.call(),
      child: Container(
        height: 60,
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(category, style: Typo.headline4.colored(textColor)),
      ),
    );
  }
}