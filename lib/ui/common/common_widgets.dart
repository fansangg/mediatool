//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/util/ui_ext.dart';

import '../../generated/assets.dart';

///@author  范三
///@version 2023/11/5
///@des     common_widget

Widget commonButton(void Function() onClick, String content) {
  return ElevatedButton(
    onPressed: onClick,
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Get.isDarkMode ? Color(0xff3056f4) : Color(0xff111111)),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 8, horizontal: 24)),
      foregroundColor: MaterialStatePropertyAll(Colors.white70),
    ),
    child: Text(content),
  );
}

Widget noPermission() {
  final textToShow = NativeChannel.instance.permissionState.value == 1
      ? "需要读取照片权限才能正常工作"
      : "需要读取照片权限才能正常工作\n请开启此权限";
  return SizedBox.expand(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Lottie.asset(Assets.lottiePermission, width: 160, height: 160),
        12.spacerH,
        Text(
          textToShow,
          textAlign: TextAlign.center,
        ),
        40.spacerH,
        if (NativeChannel.instance.permissionState.value == 1)
          commonButton(() {
            NativeChannel.instance.requestPermission();
          }, "申请权限"),
        if (NativeChannel.instance.permissionState.value == 2)
          commonButton(() {
            NativeChannel.instance.gotoSettings();
          }, "前往设置"),
      ],
    ),
  );
}
