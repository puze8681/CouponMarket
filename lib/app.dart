import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/screen/lobby/splash_page.dart';
import 'package:coupon_market/router/app_router.dart';
import 'package:coupon_market/util/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return GetMaterialApp(
      navigatorKey: Keys.mainNavigatorKey,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        primarySwatch: AppColors.primarySwatch,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: getRoute,
      navigatorObservers: [MyNavigatorObserver()],
      home: const SplashPage(),
    );
  }
}