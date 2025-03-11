import 'package:coupon_market/bloc/main/profile/edit_info_bloc.dart';
import 'package:coupon_market/component/basic/basic_button.dart';
import 'package:coupon_market/component/basic/basic_text.dart';
import 'package:coupon_market/component/basic/basic_text_field.dart';
import 'package:coupon_market/component/common/navigation.dart';
import 'package:coupon_market/component/indicator_widget.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final EditInfoBloc _bloc = EditInfoBloc();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  bool get isDoEnable {
    String name = nameController.text;
    String number = numberController.text;
    return name.isNotEmpty && number.isNotEmpty;
  }

  _onChangeText(String text){
    setState(() {});
  }

  _onClickDo() {
    String name = nameController.text;
    String number = numberController.text;
    if(isDoEnable){
      _bloc.add(DoEditInfo(name, number));
    }
  }

  _onShowDone(){
    Fluttertoast.showToast(msg: "정보가 수정되었습니다!");
  }

  @override
  void initState() {
    super.initState();
    nameController.text = firebaseManager.auth.currentUser?.displayName ?? "";
    numberController.text = authManager.number;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _EditInfoPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, EditInfoState state) async {
        if(state.message != null){
          Fluttertoast.showToast(msg: state.message!);
        }else if(state.isDone){
          _onShowDone();
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (_, EditInfoState state){
          return SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      navigationWidget,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              emailWidget,
                              const SizedBox(height: 20),
                              inputWidget,
                              const Spacer(),
                              doButton,
                              const SizedBox(height: 34),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(state.isLoading) const IndicatorWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget get navigationWidget {
    return const Navigation("내 정보 수정");
  }

  Widget get emailWidget {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F9),
        border: Border.all(color: const Color(0xffE8ECF4), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerLeft,
      child: BasicText(authManager.user.email ?? "", 14, 16, FontWeight.w400, textColor: const Color(0xff8391A1)),
    );
  }

  Widget get inputWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputBox("이름을 입력해주세요", nameController, false),
        const SizedBox(height: 20),
        inputBox("01012345678", numberController, false),
      ],
    );
  }

  Widget inputBox(String hint, TextEditingController controller, bool isObscure){
    return BasicTextField(hint, controller, isObscure: isObscure, width: double.infinity, onChanged: _onChangeText);
  }

  Widget get doButton {
    return BasicButton("수정", _onClickDo, isExpanded: true, enable: isDoEnable);
  }
}