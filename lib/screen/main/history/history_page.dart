import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:coupon_market/bloc/main/history/history_bloc.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/common/test_result_widget.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/component/modal/category_add_modal.dart';
import 'package:coupon_market/component/modal/category_delete_modal.dart';
import 'package:coupon_market/component/modal/default_modal.dart';
import 'package:coupon_market/component/modal/image_modal.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/model/test_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  final HistoryBloc _bloc = HistoryBloc();

  _onClickNotice(){
    Navigator.pushNamed(context, routeNotificationPage);
  }

  _onClickCategory(String? category){
    if(category != null){
      showModal(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return CategoryDeleteModal(
            category: category,
            onClickDelete: (){
              Navigator.of(context).pop();
              _bloc.add(DeleteCategoryHistory(category));
            },
          );
        },
      );
    }else{
      showModal(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return CategoryAddModal(
            onClickAdd: (categoryName){
              Navigator.of(context).pop();
              _bloc.add(AddCategoryHistory(categoryName));
            },
          );
        },
      );
    }
  }

  _onClickTest(TestResult testResult) async {
    await Navigator.pushNamed(context, routeBluetoothResultPage, arguments: {"testResult": testResult});
    _onUpdateTest(testResult);
  }

  _onUpdateTest(TestResult testResult){
    _bloc.add(UpdateHistory(testResult.id));
  }

  _onClickImage(TestResult testResult){
    showModal(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ImageModal(
          onClickCamera: ()=>_onClickCamera(testResult),
          onClickGallery: ()=> _onClickGallery(testResult),
        );
      },
    );
  }

  ImagePicker picker = ImagePicker();
  _onClickCamera(TestResult testResult) async {
    Navigator.of(context).pop();
    picker.pickImage(source: ImageSource.camera).then((value) async {
      if(value != null){
        File file = File(value.path.toString());
        _setFile(testResult, file);
      }
    }).onError((error, stackTrace) => _onHandleError(error));
  }

  _onClickGallery(TestResult testResult) async {
    Navigator.of(context).pop();
    picker.pickImage(source: ImageSource.gallery).then((value) async {
      if(value != null){
        File file = File(value.path.toString());
        _setFile(testResult, file);
      }
    }).onError((error, stackTrace) => _onHandleError(error));
  }

  _setFile(TestResult testResult, File file) async {
    _bloc.add(ImageHistory(testResult, file));
  }

  _onHandleError(Object? error){
    if(error is PlatformException){
      getPermission();
    }
  }

  Future<void> getPermission() async {
    final statusStorage = await Permission.storage.request();
    final statusCamera = await Permission.camera.request();
    if (statusStorage == PermissionStatus.granted && statusCamera == PermissionStatus.granted) {
      /// 둘 다 APPROVED
      print('Permission granted');
    } else if (statusStorage == PermissionStatus.permanentlyDenied || statusCamera == PermissionStatus.permanentlyDenied) {
      /// 둘 다 PERMANENT DENIED
      print('Take the user to the settings page.');
      await openAppSettings();
    } else if (statusStorage == PermissionStatus.denied || statusCamera == PermissionStatus.denied) {
      /// 1개 이상 DENIED
      print('Permission denied. Show a dialog and again ask for the permission');
    }
  }

  late ScrollController controller;
  bool isLoadMoreEnable = false;
  void _scrollListener() {
    if(isLoadMoreEnable){
      if (controller.position.extentAfter < 500) {
        isLoadMoreEnable = false;
        _bloc.add(LoadMoreHistory());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    _bloc.add(InitHistory());
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

extension on _HistoryPageState {
  Widget get _body {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (_, HistoryState state) {
            if(!state.isLoading) {
              isLoadMoreEnable = true;
            }
            if(state.message != null){
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (_, HistoryState state) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        navigation,
                        categoryWidget(state.categoryList),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: testWidget(state.testList),
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
    return Navigation("History", isBackButton: false, rightButton: Align(
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

  Widget categoryWidget(List<String> categoryList) {
    String text = categoryList.isNotEmpty ? "You can delete a category by clicking it" : "Press add button to add a category";
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              BasicText(text, 14, 18, FontWeight.w500, textColor: (const Color(0xff898989))),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => categoryItem(categoryList[index]),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 6),
                    itemCount: categoryList.length,
                  ),
                  if(categoryList.isNotEmpty) const SizedBox(width: 6),
                  if(categoryList.length < 5) categoryItem(null),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryItem(String? name) {
    return GestureDetector(
      onTap: ()=>_onClickCategory(name),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xffEFF4FF),
          borderRadius: BorderRadius.circular(6), // 20px radius
        ),
        alignment: Alignment.center,
        child: BasicText(name ?? "+", 14, 18, FontWeight.w500, textColor: AppColors.primary),
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
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
            itemCount: testList.length,
          )
        ],
      ),
    );
  }
}