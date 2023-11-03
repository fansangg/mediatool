import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/generated/assets.dart';
import 'package:media_tool/ui/splash/translationx.dart';
import 'package:media_tool/util/ui_ext.dart';

import 'controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox.expand(
        child: AnimatedOpacity(
          opacity: controller.startAnim.value ? 1 : 0,
          duration: const Duration(seconds: 1,milliseconds: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TranslationX(
                axisDirection: AxisDirection.left,
                animationController: controller.animController,
                child: Image.asset(Assets.imageIcLauncher, width: 120, height: 120),
              ),
              20.spacerH,
              TranslationX(
                axisDirection: AxisDirection.right,
                animationController: controller.animController,
                child: Text(
                  "Media tool",
                  style: TextStyle(
                    inherit: false,
                    fontFamily: "myfont",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.displayMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
