import 'package:get/get.dart';

import 'controller.dart';

class SyncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SyncController());
  }
}
