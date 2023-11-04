import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ExifPage extends StatelessWidget {
  ExifPage({Key? key}) : super(key: key);

  final controller = Get.find<ExifController>();
  final state = Get.find<ExifController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
