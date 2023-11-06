//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:media_tool/ui/common/ui_state.dart';

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

extension UiStateExt on Rx<UiState>{
  void showSuccess(){
    value = UiState.success;
  }

  void showEmpty(){
    value = UiState.empty;
  }

  void showError(){
    value = UiState.failed;
  }

  void showLoading(){
    value = UiState.loading;
  }
}
