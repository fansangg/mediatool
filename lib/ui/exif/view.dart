import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_tool/ui/common/state_layout.dart';

import 'controller.dart';

class ExifPage extends StatelessWidget {
  ExifPage({Key? key}) : super(key: key);

  final controller = Get.find<ExifController>();
  final state = Get.find<ExifController>().state;

  @override
  Widget build(BuildContext context) {
    return StateLayout(state: state.uiState.value, child: const Text("success"));
  }
}
