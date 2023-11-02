//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/material.dart';

///@author  fansan
///@version 2023/11/1
///@des     ui_ext

extension SpacerExt on num {
  SizedBox get spacerW => SizedBox(
        width: toDouble(),
      );

  SizedBox get spacerH => SizedBox(
        height: toDouble(),
      );
}

extension WidgetExt on Widget{
  Widget onClick(void Function() click){
    return GestureDetector(
      onTap: click,
      child: this,
    );
  }
}
