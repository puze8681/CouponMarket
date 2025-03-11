import 'dart:developer';
import 'dart:ui';

import 'package:coupon_market/bloc/main/notification/notification_bloc.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/model/notification_data.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  final NotificationBloc _bloc = NotificationBloc();

  _onClickNotification(NotificationData notification){
    log("_onClickNotification: ${notification.toJson()}");
    _bloc.add(ReadNotification(notification.createdAt));
  }

  late ScrollController controller;
  bool isLoadMoreEnable = false;
  void _scrollListener() {
    if(isLoadMoreEnable){
      if (controller.position.extentAfter < 500) {
        isLoadMoreEnable = false;
        _bloc.add(LoadNotification());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    _bloc.add(LoadNotification());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _NotificationPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, NotificationState state) {
            if(!state.isLoading) {
              isLoadMoreEnable = true;
            }
            if(state.message != null){
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, NotificationState state) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        navigation,
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: notificationWidget(state.notificationList),
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
    return const Navigation("알림함");
  }

  Widget notificationWidget(List<NotificationData> notificationList) {
    final DateFormat formatter = DateFormat('MMM dd');
    final Map<String, List<NotificationData>> result = {};

    for (final notification in notificationList) {
      final dateKey = formatter.format(notification.createdAt);
      result.putIfAbsent(dateKey, () => []);
      result[dateKey]!.add(notification);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            String key = result.keys.toList()[index];
            List<NotificationData> list = result[key] ?? [];
            return notificationClusteredWidget(key, list);
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
          itemCount: result.keys.length,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Color(0xffF7F8FA),
        ),
      ],
    );
  }

  Widget notificationClusteredWidget(String date, List<NotificationData> notificationList){
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xffF7F8FA),
            boxShadow: [
              BoxShadow(
                color: Color(0x00000005),  // 그림자 색상과 투명도
                blurRadius: 4,  // 흐림 정도
                spreadRadius: 0,  // 그림자 확산 정도
                offset: Offset(0, 4),  // 그림자 위치 (x, y)
                blurStyle: BlurStyle.inner,  // inner shadow 설정
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          child: BasicText(date, 14, 18, FontWeight.w500, textColor: const Color(0xff696D70)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => notificationItem(notificationList[index]),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
          itemCount: notificationList.length,
        )
      ],
    );
  }

  Widget notificationItem(NotificationData notification){
    return GestureDetector(
      onTap: () => _onClickNotification(notification),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x00000005),  // 그림자 색상과 투명도
              blurRadius: 4,  // 흐림 정도
              spreadRadius: 0,  // 그림자 확산 정도
              offset: Offset(0, 4),  // 그림자 위치 (x, y)
              blurStyle: BlurStyle.inner,  // inner shadow 설정
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0xffEFF2F8)),
                borderRadius: BorderRadius.circular(360),
              ),
              alignment: Alignment.center,
              child: const AssetWidget(Assets.ic_notification_notice, width: 24, height: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(!notification.isRead) Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(child: BasicText(notification.text, 14, 18, FontWeight.w500, textColor: const Color(0xff30333E), textAlign: TextAlign.start))
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                const SizedBox(height: 4),
                BasicText(notification.createdAt.format("HH:mm"), 10, 13, FontWeight.w500, textColor: const Color(0xff898989)),
                const Spacer(),
              ],
            )
          ],
        )
      ),
    );
  }
}