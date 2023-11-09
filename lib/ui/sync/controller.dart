import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:media_tool/util/ui_ext.dart';

import '../../service/native_channel.dart';
import 'media_entity.dart';
import 'state.dart';

class SyncController extends GetxController {
  final SyncState state = SyncState();
  StreamSubscription<dynamic>? permissionStream;

  final noDateList = <MediaEntity>[].obs;
  final notSyncList = <MediaEntity>[].obs;

  void getResult() async {
    var ret = await NativeChannel.instance.checkNoSync();
    if(ret != null && ret.isNotEmpty){
      final result = ret.map((e) => MediaEntity.fromJson(e)).toList();
      LogUtil.d("size == ${ret.length} --- result == ${result.toString()}", tag: "fansangg");
      noDateList.value = result.where((element) => (element.taken??0) <= 0).toList();
      notSyncList.value = result.where((element) => (element.taken??0) > 0).toList();
      state.uiState.showSuccess();
    }else{
      state.uiState.showEmpty();
    }
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
  }

  @override
  void onClose() {
    permissionStream?.cancel();
    super.onClose();
  }
}
