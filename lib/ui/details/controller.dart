import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:media_tool/service/native_channel.dart';
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
  void onReady() async {
    super.onReady();
    var ret = await NativeChannel.instance.getExif(entity.path??"",entity.type??0);
    LogUtil.d("ret == $ret", tag: "fansangg");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
