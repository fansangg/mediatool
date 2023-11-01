import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AlbumPage extends StatelessWidget {
  AlbumPage({Key? key}) : super(key: key);

  final controller = Get.find<AlbumController>();
  final state = Get.find<AlbumController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
