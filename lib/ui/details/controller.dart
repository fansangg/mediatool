import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_tool/ui/sync/media_entity.dart';

import 'state.dart';

class DetailsController extends GetxController {
  final DetailsState state = DetailsState();
  late MediaEntity entity;

  @override
  void onReady() {
    super.onReady();
    entity = Get.arguments;
    Logger().d("entity == $entity");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
