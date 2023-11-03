import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/ui/album/bean/album_bean.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'controller.dart';

class AlbumPage extends StatelessWidget {
  AlbumPage({Key? key}) : super(key: key);

  final controller = Get.find<AlbumController>();
  final state = Get
      .find<AlbumController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择相册'),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.albumList.isNotEmpty ? ListView.builder(itemBuilder: (context, index) {
          return albumCard(controller.albumList[index]);
        },
          itemCount: controller.albumList.length,
          prototypeItem: albumCard(controller.albumList[0]),
          padding: const EdgeInsets.symmetric(vertical: 12),) : Container();
      }),
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
          Image.file(File(bean.firstImg ?? ""), width: 80, height: 80, fit: BoxFit.cover,),
          12.spacerW,
          Text("${bean.albumName}(${bean.count})", textAlign: TextAlign.center,
            style: Get.theme.textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),)
        ],
      ),
    );
  }
}
