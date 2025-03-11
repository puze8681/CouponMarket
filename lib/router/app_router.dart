import 'package:coupon_market/router/app_routes.dart';
import 'package:coupon_market/screen/lobby/find/find_id_page.dart';
import 'package:coupon_market/screen/lobby/find/find_pw_page.dart';
import 'package:coupon_market/screen/lobby/guide_page.dart';
import 'package:coupon_market/screen/lobby/login_page.dart';
import 'package:coupon_market/screen/lobby/register/register_auth_page.dart';
import 'package:coupon_market/screen/lobby/register/register_info_page.dart';
import 'package:coupon_market/screen/lobby/term/term_detail_page.dart';
import 'package:coupon_market/screen/lobby/term/term_page.dart';
import 'package:coupon_market/screen/main/main_page.dart';
import 'package:coupon_market/screen/lobby/splash_page.dart';
import 'package:coupon_market/screen/main/notification/notification_page.dart';
import 'package:coupon_market/screen/main/profile/change_pw_page.dart';
import 'package:coupon_market/screen/main/profile/edit_info_page.dart';
import 'package:coupon_market/screen/main/profile/profile_page.dart';
import 'package:coupon_market/screen/main/profile/profile_term_page.dart';
import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  static List<Route<dynamic>> routeStack = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute!);
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}

Route getRoute(RouteSettings settings) {
  Map<String, dynamic> arg = settings.arguments == null ? {} : settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case routeSplashPage: return MaterialPageRoute(builder: (_) => const SplashPage());
    case routeGuidePage: return MaterialPageRoute(builder: (_) => const GuidePage());
    case routeLoginPage: return MaterialPageRoute(builder: (_) => const LoginPage());
    case routeFindIdPage: return MaterialPageRoute(builder: (_) => const FindIdPage());
    case routeFindPasswordPage: return MaterialPageRoute(builder: (_) => const FindPwPage());
    case routeAuthTermPage: return MaterialPageRoute(builder: (_) => TermPage(needRegister: arg['needRegister']));
    case routeAuthRegisterPage: return MaterialPageRoute(builder: (_) => const RegisterAuthPage());
    case routeAuthInfoPage: return MaterialPageRoute(builder: (_) => const RegisterInfoPage());
    case routeTermDetailPage: return MaterialPageRoute(builder: (_) => TermDetailPage(type: arg['type']));
    case routeMainPage: return MaterialPageRoute(builder: (_) => const MainPage());
    case routeEditInfoPage: return MaterialPageRoute(builder: (_) => const EditInfoPage());
    case routeChangePwPage: return MaterialPageRoute(builder: (_) => const ChangePwPage());
    case routeProfileTermPage: return MaterialPageRoute(builder: (_) => ProfileTermPage(title: arg['title'], content: arg['content']));
    case routeNotificationPage: return MaterialPageRoute(builder: (_) => const NotificationPage());
    case routeProfilePage: return MaterialPageRoute(builder: (_) => const ProfilePage());
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
}