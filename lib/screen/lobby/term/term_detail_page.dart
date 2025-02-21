import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class TermDetailPage extends StatefulWidget {
  final String type;
  const TermDetailPage({super.key, required this.type});

  @override
  State<StatefulWidget> createState() => _TermDetailPageState();
}

class _TermDetailPageState extends State<TermDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _TermDetailPageState {
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
    return Navigation(widget.type.termName);
  }

  Widget get contentWidget {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: BasicText(widget.type.termContent, 14, 16, FontWeight.w500, textColor: const Color(0xff30333E), textAlign: TextAlign.left)
          ),
        ),
      ),
    );
  }
}