import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key}) : super(key: key);

  final controller = Get.find<DetailsController>();
  final state = Get.find<DetailsController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
