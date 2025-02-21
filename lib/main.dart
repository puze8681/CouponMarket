import 'package:coupon_market/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async => await initConfiguration();

Future<void> initConfiguration() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}