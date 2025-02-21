import 'package:coupon_market/bloc/lobby/splash_bloc.dart';
import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashBloc _bloc = SplashBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(InitSplash());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body,
    );
  }
}

extension on _SplashPageState {
  Widget get _body {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext _, SplashState state) async {
        if(state is SplashDone){
          Navigator.of(context).pushReplacementNamed(routeMainPage);
        }else if(state is SplashNeedLogin){
          Navigator.of(context).pushReplacementNamed(routeGuidePage);
        }
      },
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AssetWidget(Assets.ic_fab_plus, width: 34, height: 64),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                width: 100.0,
                height: 29.0,
                child: const AssetWidget(
                  Assets.ic_tab_my,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget get _body {
  //   return BlocListener(
  //     bloc: _bloc,
  //     listener: (BuildContext _, SplashState state) async {
  //       if(state is SplashDone){
  //         Navigator.of(context).pushReplacementNamed(routeMainPage);
  //       }
  //     },
  //     child: SafeArea(
  //       child: Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: MediaQuery.of(context).size.height,
  //         alignment: Alignment.center,
  //         child: AssetWidget(
  //           Assets.ic_splash,
  //           width: MediaQuery.of(context).size.height-54,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}