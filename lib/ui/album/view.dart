import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_tool/generated/assets.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/ui/album/bean/album_bean.dart';
import 'package:media_tool/ui/common/common_widgets.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'controller.dart';

class AlbumPage extends StatelessWidget {
  AlbumPage({Key? key}) : super(key: key);

  final controller = Get.find<AlbumController>();
  final state = Get.find<AlbumController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择相册'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          switch (state.permissionState.value) {
            case 0:
              return controller.albumList.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        return albumCard(controller.albumList[index]);
                      },
                      separatorBuilder: (context,index){
                        return 12.spacerH;
                      },
                      itemCount: controller.albumList.length,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    )
                  : Container();
            case -1:
              return Container();
            default:
              return noPermission();
          }
        },
      ),
    );
  }

  Widget albumCard(AlbumBean bean) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.file(
            File(bean.firstImg ?? ""),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          12.spacerW,
          Text(
            "${bean.albumName}(${bean.count})",
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Widget noPermission() {
    final textToShow = state.permissionState.value == 1 ? "需要读取照片权限才能正常工作" : "需要读取照片权限才能正常工作\n请开启此权限";
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Lottie.asset(Assets.lottiePermission, width: 160, height: 160),
          12.spacerH,
          Text(textToShow,textAlign: TextAlign.center,),
          40.spacerH,
          if (state.permissionState.value == 1)
            commonButton(() {
              controller.getPermission();
            }, "申请权限"),
          if (state.permissionState.value == 2)
            commonButton(() {
              NativeChannel.instance.gotoSettings();
            }, "前往设置"),
        ],
      ),
    );
  }
}
