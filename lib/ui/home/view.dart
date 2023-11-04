import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/generated/assets.dart';
import 'package:media_tool/route/my_route_config.dart';
import 'package:media_tool/ui/home/home_item_bean.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final controller = Get.find<HomeController>();
  final funcList = [
    HomeItemBean(
      "同步修改日期",
      Assets.imageDate,
    ),
    HomeItemBean(
      "元数据修改",
      Assets.imageExif,
    ),
    HomeItemBean(
      "批量重命名",
      Assets.imageFile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    controller.theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('欢迎使用'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: funcList.map((e) => _gridItem(e, funcList.indexOf(e))).toList(),
      ),
    );
  }

  Widget _gridItem(HomeItemBean bean, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: controller.theme.colorScheme.secondary,
              child: Image.asset(
                bean.icon,
                width: 60,
                height: 60,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(bean.title),
          ),
        ],
      ),
    ).onClick(() {
      switch (index) {
        case 0:
          Get.toNamed(MyRouteConfig.album);
        case 1:
          Get.toNamed(MyRouteConfig.album);
        default:
          Get.toNamed(MyRouteConfig.album);
      }
    });
  }
}
