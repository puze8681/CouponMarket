import 'package:coupon_market/bloc/main/main_bloc.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/text_modal.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/manager/location_manager.dart';
import 'package:coupon_market/screen/main/history/history_page.dart';
import 'package:coupon_market/screen/main/home/home_page.dart';
import 'package:coupon_market/screen/main/main_tab_item.dart';
import 'package:coupon_market/screen/main/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/util/extensions.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController tabController;
  final MainBloc _bloc = MainBloc();

  _onClickFab() async {
    Navigator.pushNamed(context, routeBluetoothScanPage);
  }

  int lastTabIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      if(tabController.index == 3){
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
      }else if(tabController.index != 2){
        lastTabIndex = tabController.index;
        setState(() {});
      }else{
        lastTabIndex = 0;
        tabController.animateTo(0);
      }
    });
  }

  _onAnimateTab(int index){
    tabController.animateTo(index);
  }

  DateTime? backButtonPressedTime;
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (_, state) {},
      child: WillPopScope(
        onWillPop: () async {
          if(tabController.index == 0){
            DateTime currentTime = DateTime.now();

            bool backButton = backButtonPressedTime == null || currentTime.difference(backButtonPressedTime!) > const Duration(seconds: 3);

            if (backButton) {
              backButtonPressedTime = currentTime;
              Fluttertoast.showToast(
                  msg: "한번 더 클릭시 앱이 종료됩니다.",
                  backgroundColor: AppColors.mainText.withOpacity(0.65),
                  textColor: Colors.white);
              return false;
            }
            return true;
          }else{
            tabController.animateTo(0);
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF7F9FC),
          floatingActionButton: _fab,
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomePage(onAnimateTab: _onAnimateTab),
                const HistoryPage(),
                const SizedBox(),
                const SizedBox(),
                const ProfilePage(),
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
                        text: "Home",
                        activeIcon: Assets.ic_tab_home_selected,
                        inactiveIcon: Assets.ic_tab_home,
                        isActive: tabController.index == 0,
                      ),
                      MainTabItem(
                        text: "History",
                        activeIcon: Assets.ic_tab_history_selected,
                        inactiveIcon: Assets.ic_tab_history,
                        isActive: tabController.index == 1,
                      ),
                      const SizedBox(),
                      MainTabItem(
                        text: "Shop",
                        activeIcon: Assets.ic_tab_shopping_selected,
                        inactiveIcon: Assets.ic_tab_shopping,
                        isActive: tabController.index == 3,
                      ),
                      MainTabItem(
                        text: "Profile",
                        activeIcon: Assets.ic_tab_my_selected,
                        inactiveIcon: Assets.ic_tab_my,
                        isActive: tabController.index == 4,
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
      ),
    );
  }
}

extension on _MainPageState {
  Widget get _fab {
    return GestureDetector(
      onTap: _onClickFab,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const AssetWidget(Assets.ic_fab_plus, width: 30, height: 30),
      ),
    );
  }
}