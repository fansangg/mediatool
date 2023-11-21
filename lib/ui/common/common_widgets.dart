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
    child: Text(content,style: Theme.of(Get.context!).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,),),
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

Widget commonEmpty(String text) {
  return SizedBox.expand(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(Assets.lottie404, width: 150, height: 150),
        8.spacerH,
        Text(
          text,
          style: Get.theme.textTheme.bodyLarge,
        ),
      ],
    ),
  );
}

Widget commonConfirmDialog(
    String icon, String content,VoidCallback confirm,{VoidCallback? cancel}) {
  return Container(
    color: Colors.transparent,
    alignment: Alignment.center,
    child: Card(
      child: SizedBox(
        width: Get.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              12.spacerH,
              Image.asset(
                icon,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: 18,
                ),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: commonButton(() {
                      Get.back();
                      cancel?.call();
                    }, " 取消 "),
                  ),
                  18.spacerW,
                  Expanded(
                    flex: 1,
                    child: commonButton(() {
                      confirm();
                    }, " 确定 "),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
