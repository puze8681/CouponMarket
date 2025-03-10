import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<StatefulWidget> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  _onClickLogin(){
    Navigator.of(context).pushReplacementNamed(routeLoginPage);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _GuidePageState {
  Widget get _body {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 64),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  _buildPageContent("가이드 사진 1"),
                  _buildPageContent("가이드 사진 2"),
                  _buildPageContent("가이드 사진 3"),
                ],
              ),
            ),
            const SizedBox(height: 60),
            _indicatorWidget,
            const SizedBox(height: 20),
            buttonWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(String assets) {
    return Container(
      color: Colors.grey,
      width: 310,
      height: 464,
      alignment: Alignment.center,
      child: Text(assets),
    );
  }

  Widget get _indicatorWidget {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPageIndicator(),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _totalPages; i++) {
      indicators.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget get buttonWidget {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 42),
        child: GestureDetector(
          onTap: _onClickLogin,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text('시작하기', style: Typo.headline3.colored(AppColors.white)),
          ),
        )
    );
  }
}