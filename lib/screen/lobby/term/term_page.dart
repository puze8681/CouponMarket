import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class TermPage extends StatefulWidget {
  final bool needRegister;
  const TermPage({super.key, required this.needRegister});

  @override
  State<StatefulWidget> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {

  List<String> selectedTermList = [];
  // bool get isAllAgree => selectedTermList.length == 4;
  bool get isAllAgree => selectedTermList.length == 2;
  void _onClickAllAgree(){
    setState(() {
      if(isAllAgree){
        selectedTermList = [];
      }else{
        // selectedTermList = ["AGE", "TOS", "PRIVACY", "MARKETING"];
        selectedTermList = ["TOS", "PRIVACY"];
      }
    });
  }
  void _onClickAgree(String type){
    setState(() {
      if(selectedTermList.contains(type)){
        selectedTermList.remove(type);
      }else{
        selectedTermList.add(type);
      }
    });
  }
  void _onClickTerm(String type){
    Map<String, dynamic> args = {"type": type};
    Navigator.pushNamed(context, routeTermDetailPage, arguments: args);
  }

  // bool get isDoneEnable => selectedTermList.contains("AGE") && selectedTermList.contains("TOS") && selectedTermList.contains("PRIVACY");
  bool get isDoneEnable => selectedTermList.contains("TOS") && selectedTermList.contains("PRIVACY");
  void _onClickDone(){
    if(widget.needRegister){
      Navigator.pushNamed(context, routeAuthRegisterPage);
    }else{
      Navigator.pushNamed(context, routeAuthInfoPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _TermPageState {
  Widget get _body {
    return SafeArea(
      child: SizedBox(
        child: Column(
          children: [
            navigationWidget,
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 44),
                    agreeWidget,
                    const Spacer(),
                    doneButton,
                    const SizedBox(height: 34),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get navigationWidget {
    return const Navigation("");
  }
  Widget get titleWidget {
    return const BasicText("Please agree to\nthe Terms of Service.", 20, 24, FontWeight.w600, textColor: Color(0xff30333E));
  }

  Widget get agreeWidget {
    return Column(
      children: [
        allAgreeButton,
        const SizedBox(height: 18),
        // agreeButton("AGE"),
        agreeButton("TOS"),
        agreeButton("PRIVACY"),
        // agreeButton("MARKETING"),
      ],
    );
  }

  Widget get allAgreeButton {
    Color assetColor = isAllAgree ? AppColors.primary : const Color(0xffC9C9C9);
    Color textColor = isAllAgree ? const Color(0xff30333E) : const Color(0xff696D70);
    return GestureDetector(
      onTap: _onClickAllAgree,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(6),
        ),
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AssetWidget(Assets.ic_agree_check, width: 28, height: 28, color: assetColor),
            const SizedBox(width: 4),
            Expanded(child: BasicText("Agree to All Terms", 14, 16, FontWeight.w500, textColor: textColor)),
          ],
        ),
      ),
    );
  }

  Widget agreeButton(String type) {
    bool isAgree = selectedTermList.contains(type);
    Color assetColor = isAgree ? AppColors.primary : const Color(0xffE9E9E9);
    return Container(
      height: 54,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onClickAgree(type),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AssetWidget(Assets.ic_agree_check, width: 28, height: 28, color: assetColor),
                    const SizedBox(width: 4),
                    Expanded(child: BasicText(type.termTitle, 14, 16, FontWeight.w500, textColor: const Color(0xff898989))),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _onClickTerm(type),
            child: Container(
              color: Colors.transparent,
              child: const AssetWidget(Assets.ic_agree_right, width: 24, height: 24, color: Color(0xff898989)),
            ),
          ),
        ],
      ),
    );
  }

  Widget get doneButton {
    return BasicButton("Done", _onClickDone, isExpanded: true, enable: isDoneEnable);
  }
}