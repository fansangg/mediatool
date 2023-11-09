import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/ui/album/bean/album_bean.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'state.dart';

class AlbumController extends GetxController {
  final AlbumState state = AlbumState();
  var albumList = <AlbumBean>[].obs;
  StreamSubscription<dynamic>? permissionStream;

  void getAllAlbum() async {
    var ret = await NativeChannel.instance.getAllAlbum();
    if (ret != null && ret.isNotEmpty) {
      albumList.value = ret.map((e) => AlbumBean.fromJson(e)).toList();
      state.uiState.showSuccess();
    } else {
      state.uiState.showEmpty();
    }
  }


  @override
  void onReady() {
    if(NativeChannel.instance.permissionState.value == 0) {
      getAllAlbum();
    }else{
      NativeChannel.instance.requestPermission();
      permissionStream = NativeChannel.instance.permissionState.listen((p0) {
        LogUtil.d("p0 == $p0", tag: "fansangg");
        if (p0 == 0) {
          getAllAlbum();
        }else{
          state.uiState.showError();
        }
      });
    }
    super.onReady();
  }

  @override
  void onClose() {
    permissionStream?.cancel();
    super.onClose();
  }
}
