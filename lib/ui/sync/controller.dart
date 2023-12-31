import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:media_tool/ui/common/common_widgets.dart';
import 'package:media_tool/util/ui_ext.dart';

import '../../service/native_channel.dart';
import 'media_entity.dart';
import 'state.dart';

class SyncController extends GetxController with GetSingleTickerProviderStateMixin {
  final SyncState state = SyncState();
  StreamSubscription<dynamic>? permissionStream;
  StreamSubscription<dynamic>? eventStream;

  final noDateList = <MediaEntity>[].obs;
  final notSyncList = <MediaEntity>[].obs;
  late TabController tabController;

  void getResult() async {
    var ret = await NativeChannel.instance.checkNoSync();
    if(ret != null){
      final result = ret.map((e) => MediaEntity.fromJson(e)).toList();
      LogUtil.d("size == ${ret.length} --- result == ${result.toString()}",
          tag: "fansangg");
      /*noDateList.value = result
          .where((element) => (element.taken ?? 0) <= 0 && element.type != 3)
          .toList();*/
      noDateList.value = result.where((element) => (element.taken ?? 0) > 0).toList();
      notSyncList.value =
          result.where((element) => (element.taken ?? 0) > 0).toList();
    }
    state.uiState.showSuccess();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      state.currentIndex.value = tabController.index;
    });
  }

  @override
  void onReady() {
    super.onReady();
    if(NativeChannel.instance.permissionState.value == 0) {
      getResult();
    }else{
      NativeChannel.instance.requestPermission();
      permissionStream = NativeChannel.instance.permissionState.listen((p0) {
        if (p0 == 0) {
          getResult();
        }else{
          state.uiState.showError();
        }
      });
    }

    eventStream =  const EventChannel("event").receiveBroadcastStream().listen((event) {
      var data = jsonDecode(event) as Map<String, dynamic>;
      LogUtil.d("data = $data", tag: "fansangg");
      switch (data['tag']) {
        case "modify":
          var path = data['path'];
          var progress = data['progress'];
          var total = data['total'];
          state.processMap['progress'] = progress;
          state.processMap['total'] = total;
          if (Get.isDialogOpen == false) {
            Get.dialog(processDialog(state.processMap));
          }
          notSyncList.removeWhere((element) => element.path == path);
          if (progress == total) {
            Get.back();
          }
        case "modifyResult":
          var success = data['success'];
          var error = data['error'];
          Get.dialog(commonConfirmDialog("成功：$success,失败：$error"));
        case "permissionDenied":
          Get.dialog(commonConfirmDialog("此操作需要您允许修改这些文件"));
        default:
          LogUtil.d("no match tag", tag: "fansangg");
      }
    });
  }

  @override
  void onClose() {
    permissionStream?.cancel();
    tabController.dispose();
    eventStream?.cancel();
    super.onClose();
  }
}
