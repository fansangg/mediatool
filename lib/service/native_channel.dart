//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/services.dart';
import 'package:get/get.dart';

///@author  fansan
///@version 2023/11/3
///@des     native_channel 

class NativeChannel extends GetxService{

  static NativeChannel get instance => Get.find();
  final _nativeChannel = MethodChannel("native");

  Future<void> requestPermission() async  {
    return await _nativeChannel.invokeMethod("getPermission");
  }

  Future<List<dynamic>?> getAllAlbum() async {
    return await _nativeChannel.invokeListMethod("getAllAlbum");
  }

  void gotoSettings(){
    _nativeChannel.invokeMethod("gotoSettings");
  }
}


 

