import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/generated/assets.dart';
import 'package:media_tool/route/my_route_config.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/ui/common/state_layout.dart';
import 'package:media_tool/ui/sync/media_entity.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'controller.dart';

class SyncPage extends StatelessWidget {
  SyncPage({Key? key}) : super(key: key);

  final controller = Get.find<SyncController>();
  final state = Get.find<SyncController>().state;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('查询结果'),
          bottom: TabBar(
            tabs: const [
              Tab(
                text: "日期不同步",
              ),
              Tab(
                text: "缺少拍摄日期",
              ),
            ],
            dividerColor: Theme.of(context).colorScheme.background,
            labelColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        body: Obx(() {
          return StateLayout(
            state: state.uiState.value,
            child: TabBarView(
              children: [
                _resultPage(0),
                _resultPage(1),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _resultPage(int type) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 6, crossAxisSpacing: 6),
      itemBuilder: (context, index) {
        return _resultItem(
            type == 0
                ? controller.notSyncList[index]
                : controller.noDateList[index],
            type);
      },
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 30, top: 12),
      itemCount: type == 0
          ? controller.notSyncList.length
          : controller.noDateList.length,
    );
  }

  Widget _resultItem(MediaEntity entity, int type) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Image.file(
                  File( entity.type == 1
                      ? entity.path ?? "" : entity.thumbnail ?? ""),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
          if (entity.type == 3)
            const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.smart_display_rounded,
                size: 30,
              ),
            ),
        ],
      ),
    ).onClick(() {
      Get.toNamed(MyRouteConfig.details,arguments: entity);
    });
  }

  Widget _videoItem(String uri) {
    return FutureBuilder<String>(
        future: NativeChannel.instance.getVideoThumbnail(uri),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.file(
              File(snapshot.data??""),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          } else {
            return Image.asset(
              Get.isDarkMode
                  ? Assets.imagePlaceholderDark
                  : Assets.imagePlaceholderLight,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          }
        });
  }
}
