import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:media_tool/route/my_route_config.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  var startAnim = false.obs;
  late final AnimationController animController;

  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  void onReady() {
    startAnim.value = true;
    animController.forward();
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offNamed(MyRouteConfig.root),
    );
    super.onReady();
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}
