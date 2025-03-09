import 'dart:ui';

import 'package:coupon_market/bloc/main/store/store_bloc.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/common/store_widget.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/category_add_modal.dart';
import 'package:coupon_market/component/modal/category_delete_modal.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/model/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  final StoreBloc _bloc = StoreBloc();

  _onClickNotice(){
    Navigator.pushNamed(context, routeNotificationPage);
  }

  _onClickStore(Store store) async {
    // await Navigator.pushNamed(context, routeBluetoothResultPage, arguments: {"testResult": testResult});
  }

  late ScrollController controller;
  bool isLoadMoreEnable = false;
  void _scrollListener() {
    if(isLoadMoreEnable){
      if (controller.position.extentAfter < 500) {
        isLoadMoreEnable = false;
        _bloc.add(LoadMoreStore());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    _bloc.add(InitStore());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _StorePageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, StoreState state) {
            if(!state.isLoading) {
              isLoadMoreEnable = true;
            }
            if(state.message != null){
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, StoreState state) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        navigation,
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: testWidget(state.storeList),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(state.isLoading) const IndicatorWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget get navigation {
    return Navigation("Store", isBackButton: false, rightButton: Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _onClickNotice,
        child: Container(
          color: Colors.transparent,
          child: const AssetWidget(Assets.ic_profile_notice, width: 24, height: 24),
        ),
      ),
    ));
  }

  Widget testWidget(List<Store> storeList) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Store", style: Typo.headline4),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => StoreWidget(
              store: storeList[index], 
              onClickStore: _onClickStore,
            ),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
            itemCount: storeList.length,
          )
        ],
      ),
    );
  }
}