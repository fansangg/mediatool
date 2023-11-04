//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author  范三
///@version 2023/11/5
///@des     common_widget

Widget commonButton(void Function() onClick, String content) {
  return ElevatedButton(
    onPressed: onClick,
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Get.isDarkMode ? Color(0xff3056f4) : Color(0xff111111)),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 8, horizontal: 24)),
      foregroundColor: MaterialStatePropertyAll(Colors.white70),
    ),
    child: Text(content),
  );
}
