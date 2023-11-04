import 'package:get/get.dart';

import 'controller.dart';

class ModifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ModifyController());
  }
}
