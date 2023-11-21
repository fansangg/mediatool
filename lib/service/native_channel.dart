//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/sync/media_entity.dart';

///@author  fansan
///@version 2023/11/3
///@des     native_channel 

class NativeChannel extends GetxService{

  static NativeChannel get instance => Get.find();
  final _nativeChannel = MethodChannel("native");
  Rx<int> permissionState = (-1).obs;

  @override
  void onReady() {
    super.onReady();
    EventChannel("permission").receiveBroadcastStream().listen((event) {
      permissionState.value = event;
    });
  }

  Future<void> requestPermission() async {
    return await _nativeChannel.invokeMethod("getPermission");
  }

  Future<List<dynamic>?> getAllAlbum() async {
    return await _nativeChannel.invokeListMethod("getAllAlbum");
  }

  void gotoSettings() {
    _nativeChannel.invokeMethod("gotoSettings");
  }

  Future<List<dynamic>?> checkNoSync() async {
    return await _nativeChannel.invokeListMethod("checkNoSync");
  }

  Future<List<int>?> getVideoThumbnail(String path) async {
    return await _nativeChannel.invokeListMethod("getVideoThumbnail",path);
  }

  Future<dynamic> getExif(String path,int type) async {
    return await _nativeChannel.invokeMethod("getExif",{"path":path,"type":type});
  }

  void fixTime(List<MediaEntity> data,int type) {
    final newData = data.map((e) => e.toJson()).toList();
    _nativeChannel.invokeMethod("fixTime",{"data":newData,"type":type});
  }
}


 

