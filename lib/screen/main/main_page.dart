import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/text_modal.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/screen/main/coupon/coupon_page.dart';
import 'package:coupon_market/screen/main/main_tab_item.dart';
import 'package:coupon_market/screen/main/profile/profile_page.dart';
import 'package:coupon_market/screen/main/store/store_page.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController tabController;

  _onClickNotice() {
    Navigator.pushNamed(context, routeNotificationPage);
  }

  String tabTitle = "매장 목록";
  setTabTitle(){
    if(lastTabIndex == 1){
      tabTitle = "쿠폰";
    }else if(lastTabIndex == 2){
      tabTitle = "이벤트";
    }else if(lastTabIndex == 3){
      tabTitle = "프로필";
    }else {
      tabTitle = "매장 목록";
    }
  }

  int lastTabIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      if(tabController.index == 2){
        tabController.animateTo(lastTabIndex);
        showModal(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return TextModal(
              text: "The service is currently\nunder preparation. Please try\nagain later.",
              buttonText: "Confirm",
              onClick: ()=>Navigator.of(context).pop(),
              canPop: false,
            );
          },
        );
      }else {
        lastTabIndex = tabController.index;
        setTabTitle();
        setState(() {});
      }
    });
  }

  DateTime? backButtonPressedTime;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 시스템 뒤로가기 버튼의 자동 동작을 비활성화
      onPopInvoked: (didPop) async {
        // didPop이 true면 이미 pop 동작이 실행된 상태
        if (didPop) {
          return;
        }

        if (tabController.index == 0) {
          DateTime currentTime = DateTime.now();
          bool backButton = backButtonPressedTime == null ||
              currentTime.difference(backButtonPressedTime!) > const Duration(seconds: 3);

          if (backButton) {
            backButtonPressedTime = currentTime;
            Fluttertoast.showToast(
                msg: "한번 더 클릭시 앱이 종료됩니다.",
                backgroundColor: AppColors.mainText.withOpacity(0.65),
                textColor: Colors.white
            );
          } else {
            // 실제로 앱을 종료하려면 시스템 네비게이션을 사용
            SystemNavigator.pop();
          }
        } else {
          tabController.animateTo(0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF7F9FC),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              navigation,
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StorePage(),
                    CouponPage(),
                    SizedBox(),
                    ProfilePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 75 + context.bottomPadding,
                child: TabBar(
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: AppColors.transparent,
                  controller: tabController,
                  isScrollable: false,
                  tabs: [
                    MainTabItem(
                      text: "매장",
                      activeIcon: Assets.ic_tab_home_selected,
                      inactiveIcon: Assets.ic_tab_home,
                      isActive: tabController.index == 0,
                    ),
                    MainTabItem(
                      text: "쿠폰",
                      activeIcon: Assets.ic_tab_coupon_selected,
                      inactiveIcon: Assets.ic_tab_coupon,
                      isActive: tabController.index == 1,
                    ),
                    MainTabItem(
                      text: "이벤트",
                      activeIcon: Assets.ic_tab_shopping_selected,
                      inactiveIcon: Assets.ic_tab_shopping,
                      isActive: tabController.index == 2,
                    ),
                    MainTabItem(
                      text: "프로필",
                      activeIcon: Assets.ic_tab_my_selected,
                      inactiveIcon: Assets.ic_tab_my,
                      isActive: tabController.index == 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: _fabBtn,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget get navigation {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: BasicText(tabTitle, 16, 20, FontWeight.w500),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: _onClickNotice,
                  child: Container(
                    color: Colors.transparent,
                    child: const AssetWidget(Assets.ic_profile_notice, width: 24, height: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}