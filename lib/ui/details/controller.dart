import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:media_tool/ui/sync/media_entity.dart';

import 'state.dart';

class DetailsController extends GetxController {
  final DetailsState state = DetailsState();
  late MediaEntity entity;

  @override
  void onInit() {
    super.onInit();
    entity = Get.arguments;
    LogUtil.d("entity == $entity",tag: "fansangg");
  }

  @override
  void onReady() {
    super.onReady();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.light),
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
