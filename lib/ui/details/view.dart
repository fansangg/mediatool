import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:media_tool/generated/assets.dart';
import 'package:media_tool/service/native_channel.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'controller.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key}) : super(key: key);

  final controller = Get.find<DetailsController>();
  final state = Get.find<DetailsController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        children: [
          _buildImg,
          mediaInfo(context),
        ],
      ),
    );
  }

  Widget get _buildImg {
    final orientation = controller.entity.orientation ?? 0;
    final width = (orientation == 90 || orientation == 270)
        ? controller.entity.height ?? 0
        : controller.entity.width ?? 0;
    final height = (orientation == 90 || orientation == 270)
        ? controller.entity.width ?? 0
        : controller.entity.height ?? 0;
    double newWidth;
    double newHeight;
    if (width > height) {
      double ratio = height / width;
      newWidth = Get.width;
      newHeight = newWidth * ratio;
    } else if (width == height) {
      newWidth = Get.width;
      newHeight = newWidth;
    } else {
      if (height > 500) {
        newHeight = 500;
      } else {
        newHeight = height.toDouble();
      }

      double ratio = width / height;
      newWidth = newHeight * ratio;
    }

    return controller.entity.type == 1
        ? Center(
            child: Image.file(
              File(controller.entity.path ?? ""),
              width: newWidth,
              height: newHeight,
            ),
          )
        : FutureBuilder(
            future: NativeChannel.instance
                .getVideoThumbnail(controller.entity.path ?? ""),
            builder: (context, snapshot) {
              return Container(
                width: newWidth,
                height: newHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: snapshot.hasData
                          ? MemoryImage(Uint8List.fromList(snapshot.data ?? []))
                          : const AssetImage(Assets.imagePlaceholderDark)
                              as ImageProvider),
                ),
                child: const Icon(
                  Icons.smart_display_rounded,
                  size: 50,
                ),
              );
            },
          );
  }

  Widget mediaInfo(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.entity.fileName ?? "",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
          ),
          2.spacerH,
          Text(
            controller.entity.path ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            softWrap: false,
          ),
          6.spacerH,
          Row(
            children: [
              Text(
                (controller.entity.orientation == 0 ||
                        controller.entity.orientation == 180)
                    ? "${controller.entity.width} * ${controller.entity.height}"
                    : "${controller.entity.height} * ${controller.entity.width}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              16.spacerW,
              Text(
                _formatBytes(controller.entity.fileSize ?? 0),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          6.spacerH,
          Text(
            "添加日期：${DateUtil.formatDateMs((controller.entity.addTime ?? 0) * 1000, format: "yyyy.MM.dd HH:mm:ss")}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          6.spacerH,
          Text(
            "拍摄日期：${controller.entity.taken == 0 ? '缺失' : DateUtil.formatDateMs(controller.entity.taken ?? 0, format: "yyyy.MM.dd HH:mm:ss")}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          6.spacerH,
          Text(
            "修改日期：${DateUtil.formatDateMs((controller.entity.lastModify ?? 0) * 1000, format: "yyyy.MM.dd HH:mm:ss")}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          18.spacerH,
          Text(
            controller.entity.type == 1 ? "图片信息" : "视频信息",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          6.spacerH,
          FutureBuilder(
              future: controller.getExif(),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      snapshot.hasData ? _exifInfo(context, snapshot.data) : [],
                );
              })
        ],
      ),
    ).paddingSymmetric(vertical: 12, horizontal: 6);
  }

  List<Widget> _exifInfo(BuildContext context, dynamic data) {
    final List<Widget> infos = [];
    (data as Map).forEach((key, value) {
      if (value.isNotEmpty) {
        infos.add(
          Column(
            children: [
              Text(
                "$key:$value",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              6.spacerH,
            ],
          ),
        );
      }
    });
    return infos;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      double kb = bytes / 1024;
      return '${kb.toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      double mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(2)} MB';
    } else {
      double gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(2)} GB';
    }
  }
}
