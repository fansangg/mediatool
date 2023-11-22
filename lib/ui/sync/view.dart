import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/generated/assets.dart';
import 'package:media_tool/route/my_route_config.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/ui/common/common_widgets.dart';
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
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('查询结果'),
          bottom: TabBar(
            controller: controller.tabController,
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
        body: StateLayout(
          state: state.uiState.value,
          errorWidget: noPermission(),
          child: TabBarView(
            controller: controller.tabController,
            children: [
              _resultPage(0),
              _resultPage(1),
            ],
          ),
        ),
        floatingActionButton: _syncControllerBtn,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _resultPage(int type) {
    final List<MediaEntity> resultList;
    if (type == 0) {
      resultList = controller.notSyncList;
    } else {
      resultList = controller.noDateList;
    }

    return resultList.isEmpty
        ? commonEmpty("无查询结果")
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 6, crossAxisSpacing: 6),
            itemBuilder: (context, index) {
              return _resultItem(resultList[index], type);
            },
            padding:
                const EdgeInsets.only(left: 6, right: 6, bottom: 30, top: 12),
            itemCount: resultList.length,
          );
  }

  Widget _resultItem(MediaEntity entity, int type) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Image.file(
            File(entity.type == 1 ? entity.path ?? "" : entity.thumbnail ?? ""),
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
      Get.toNamed(MyRouteConfig.details, arguments: entity);
    });
  }

  Widget? get _syncControllerBtn {
    switch (state.currentIndex.value) {
      case 0:
        if (controller.notSyncList.isNotEmpty) {
          return commonButton(() {
            Get.dialog(
              commonConfirmDialog(
                "此操作会将媒体的最后修改日期同步为元数据日期",
                confirm: () {
                  NativeChannel.instance.fixTime(controller.notSyncList, 1);
                },
                icon: Assets.imageWarning,
                showCancel: true,
              ),
            );
          }, "一键修复");
        }
      case 1:
        if (controller.noDateList.isNotEmpty) {
          return commonButton(() {

          }, "一键添加");
        }
    }
    return null;
  }
}
