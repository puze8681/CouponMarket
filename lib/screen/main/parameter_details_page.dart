import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class ParameterDetailPage extends StatefulWidget {
  final int index;
  const ParameterDetailPage({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => _ParameterDetailPageState();
}

class _ParameterDetailPageState extends State<ParameterDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _ParameterDetailPageState {
  Widget get _body {
    return SafeArea(
      child: SizedBox(
        child: Column(
          children: [
            navigationWidget,
            contentWidget,
          ],
        ),
      ),
    );
  }

  Widget get navigationWidget {
    return const Navigation("");
  }

  Widget get contentWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const BasicText("Parameter Details", 18, 20, FontWeight.w700, textColor: Color(0xff30333E), textAlign: TextAlign.left),
                  const SizedBox(height: 32),
                  BasicText(widget.index.parameterDetail, 16, 20, FontWeight.w400, textColor: const Color(0xff30333E), textAlign: TextAlign.left),
                  const SizedBox(height: 34),
                ],
              )
          ),
        ),
      ),
    );
  }
}