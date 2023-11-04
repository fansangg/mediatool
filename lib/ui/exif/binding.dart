import 'package:get/get.dart';

import 'controller.dart';

class ExifBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExifController());
  }
}
