import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ModifyPage extends StatelessWidget {
  ModifyPage({Key? key}) : super(key: key);

  final controller = Get.find<ModifyController>();
  final state = Get.find<ModifyController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
