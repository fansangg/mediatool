//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:get/get.dart';
import 'package:media_tool/ui/home/binding.dart';
import 'package:media_tool/ui/home/view.dart';
import 'package:media_tool/ui/splash/binding.dart';
import 'package:media_tool/ui/splash/view.dart';

///@author  fansan
///@version 2023/11/1
///@des     my_route_config

class MyRouteConfig {
  static const String root = "/";
  static const String splash = "/splash";
  static const String album = "/album";

  static final List<GetPage<dynamic>> routers = [
    GetPage(
      name: splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade
    ),
    GetPage(
      name: root,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: Transition.fade
    ),
  ];
}
