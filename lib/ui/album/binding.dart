import 'package:get/get.dart';

import 'controller.dart';

class AlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlbumController());
  }
}
