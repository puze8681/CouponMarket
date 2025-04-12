import 'package:coupon_market/constant/colors.dart';
import 'package:flutter/material.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            tabBar,
            tabView
          ],
        ),
      ),
    );
  }
}

extension on _CouponPageState {
  Widget get tabBar {
    return TabBar(
      labelColor: AppColors.mainText,
      indicatorColor: AppColors.mainText,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2.0,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 20.0),
      controller: tabController,
      tabs: [
        Container(
          width: (MediaQuery.of(context).size.width) / 2,
          child: Tab(
            text: '다운받은 쿠폰',
          ),
        ),
        Container(
          width: (MediaQuery.of(context).size.width) / 2,
          child: Tab(
            text: '쿠폰 사용 내역',
          ),
        )
      ],
    );
  }
  Widget get tabView {
    if(tabController.index == 0){
      return SizedBox();
    }else{
      return SizedBox();
    }
  }
}