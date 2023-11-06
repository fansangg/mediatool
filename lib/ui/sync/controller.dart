import 'dart:async';

import 'package:get/get.dart';
import 'package:media_tool/util/ui_ext.dart';

import '../../service/native_channel.dart';
import 'state.dart';

class SyncController extends GetxController {
  final SyncState state = SyncState();
  StreamSubscription<dynamic>? permissionStream;

  void getResult(){

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
