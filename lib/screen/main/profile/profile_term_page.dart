import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class ProfileTermPage extends StatefulWidget {
  final String title;
  final String content;
  const ProfileTermPage({super.key, required this.title, required this.content});

  @override
  State<StatefulWidget> createState() => _ProfileTermPageState();
}

class _ProfileTermPageState extends State<ProfileTermPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _ProfileTermPageState {
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
                  BasicText(widget.title, 18, 20, FontWeight.w700, textColor: const Color(0xff30333E), textAlign: TextAlign.left),
                  const SizedBox(height: 24),
                  BasicText(widget.content, 16, 20, FontWeight.w400, textColor: const Color(0xff30333E), textAlign: TextAlign.left),
                  const SizedBox(height: 34),
                ],
              )
          ),
        ),
      ),
    );
  }
}