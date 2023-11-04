import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/ui/album/bean/album_bean.dart';

import 'state.dart';

class AlbumController extends GetxController {
  final AlbumState state = AlbumState();
  var albumList = <AlbumBean>[].obs;
  late StreamSubscription<dynamic> permissionStream;

  void getAllAlbum() async {
    var ret = await NativeChannel.instance.getAllAlbum();
    if (ret != null && ret.isNotEmpty) {
        albumList.value = ret.map((e) => AlbumBean.fromJson(e)).toList();
        Logger().d("albumList == ${albumList.length}");
    }
  }

  void getPermission() async {
    NativeChannel.instance.requestPermission();
  }

  @override
  void onReady() {
    permissionStream =  const EventChannel("flutter").receiveBroadcastStream().listen((event) {
      Logger().d("event == $event");
      state.permissionState.value = event;
      if(state.permissionState.value == 0){
        getAllAlbum();
      }
    });
    getPermission();
    super.onReady();
  }

  @override
  void onClose() {
    permissionStream.cancel();
    super.onClose();
  }
}
