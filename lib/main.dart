import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/route/my_route_config.dart';
import 'package:media_tool/theme/theme_config.dart';
import 'package:media_tool/service/native_channel.dart';

void main(){
  Get.put(NativeChannel());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MediaTool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black87,unselectedLabelColor: Colors.black26),
        useMaterial3: true,
      ),
      darkTheme: ThemeConfig.dark,
      initialRoute: MyRouteConfig.splash,
      getPages: MyRouteConfig.routers,
    );
  }
}
