import 'dart:io';
import 'dart:ui';

import 'package:coupon_market/bloc/main/home/home_bloc.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/image_modal.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/model/user.dart';
import 'package:coupon_market/component/common/test_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  final Function(int) onAnimateTab;

  const HomePage({super.key, required this.onAnimateTab});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeBloc _bloc = HomeBloc();

  _onClickNotice() {
    Navigator.pushNamed(context, routeNotificationPage);
  }

  _onClickConnect() {
    Navigator.pushNamed(context, routeBluetoothScanPage);
  }

  _onClickCategory(String name) {
    if (name == "Test") {
      Navigator.pushNamed(context, routeBluetoothScanPage);
    } else if (name == "History") {
      widget.onAnimateTab.call(1);
    } else if (name == "Shopping") {
      widget.onAnimateTab.call(3);
    }
  }

  _onClickTest(TestResult testResult) {
    Navigator.pushNamed(context, routeBluetoothResultPage,
        arguments: {"testResult": testResult});
  }

  _onClickImage(TestResult testResult) {
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ImageModal(
          onClickCamera: () => _onClickCamera(testResult),
          onClickGallery: () => _onClickGallery(testResult),
        );
      },
    );
  }

  ImagePicker picker = ImagePicker();

  _onClickCamera(TestResult testResult) async {
    Navigator.of(context).pop();
    picker.pickImage(source: ImageSource.camera).then((value) async {
      if (value != null) {
        File file = File(value.path.toString());
        _setFile(testResult, file);
      }
    }).onError((error, stackTrace) => _onHandleError(error));
  }

  _onClickGallery(TestResult testResult) async {
    Navigator.of(context).pop();
    picker.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        File file = File(value.path.toString());
        _setFile(testResult, file);
      }
    }).onError((error, stackTrace) => _onHandleError(error));
  }

  _setFile(TestResult testResult, File file) async {
    _bloc.add(ImageHome(testResult, file));
  }

  _onHandleError(Object? error) {
    if (error is PlatformException) {
      getPermission();
    }
  }

  Future<void> getPermission() async {
    final statusStorage = await Permission.storage.request();
    final statusCamera = await Permission.camera.request();
    if (statusStorage == PermissionStatus.granted &&
        statusCamera == PermissionStatus.granted) {
      /// 둘 다 APPROVED
      print('Permission granted');
    } else if (statusStorage == PermissionStatus.permanentlyDenied ||
        statusCamera == PermissionStatus.permanentlyDenied) {
      /// 둘 다 PERMANENT DENIED
      print('Take the user to the settings page.');
      await openAppSettings();
    } else if (statusStorage == PermissionStatus.denied ||
        statusCamera == PermissionStatus.denied) {
      /// 1개 이상 DENIED
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitHome());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _HomePageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, HomeState state) {},
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, HomeState state) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        header(0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                categoryWidget(),
                                testWidget(state.testList),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.isLoading) const IndicatorWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget header(int noticeCount) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/home/bg_header.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 170, 255, 0.09),
                    // rgba(0, 170, 255, 0.0882)
                    Color.fromRGBO(0, 13, 255, 0.42),
                    // rgba(0, 13, 255, 0.42)
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  const AssetWidget(Assets.ic_home_logo),
                  const Spacer(),
                  GestureDetector(
                    onTap: _onClickNotice,
                    child: const AssetWidget(Assets.ic_home_notice,
                        width: 24, height: 24),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 18),
              Text("Monitor Water\nProtect Life",
                  style: Typo.headline3.colored(AppColors.white),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _onClickConnect,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 12.1,
                      sigmaY: 12.1,
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withOpacity(0.15),
                        // 15% opacity
                        borderRadius: BorderRadius.circular(20),
                        // 20px radius
                        border: Border.all(
                          color: const Color(0xFFFFFFFF),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞춤
                        children: [
                          const AssetWidget(Assets.ic_home_bluetooth,
                              width: 24, height: 24),
                          const SizedBox(width: 5), // 아이콘과 텍스트 사이 간격
                          Text('Connect Your Device',
                              style: Typo.headline4.colored(AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 42),
            ],
          )
        ],
      ),
    );
  }

  Widget categoryWidget() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category", style: Typo.headline4),
          const SizedBox(height: 10),
          Row(
            children: [
              categoryItem(Assets.ic_category_test, "Test"),
              const SizedBox(width: 10),
              categoryItem(Assets.ic_category_history, "History"),
              const SizedBox(width: 10),
              categoryItem(Assets.ic_category_shopping, "Shopping"),
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryItem(String asset, String name) {
    return GestureDetector(
      onTap: () => _onClickCategory(name),
      child: Container(
        color: AppColors.transparent,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffF7F9FC),
                borderRadius: BorderRadius.circular(25), // 20px radius
              ),
              alignment: Alignment.center,
              child: AssetWidget(asset, width: 50, height: 50),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              child: Text(name,
                  style: Typo.bodyMedium3.colored(const Color(0xff738CA0))),
            ),
          ],
        ),
      ),
    );
  }

  Widget testWidget(List<TestResult> testList) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent test", style: Typo.headline4),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => TestResultWidget(
              testResult: testList[index],
              onClickTest: _onClickTest,
              onClickImage: _onClickImage,
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10),
            itemCount: testList.length,
          )
        ],
      ),
    );
  }
}
