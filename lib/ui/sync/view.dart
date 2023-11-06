import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SyncPage extends StatelessWidget {
  SyncPage({Key? key}) : super(key: key);

  final controller = Get.find<SyncController>();
  final state = Get.find<SyncController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
