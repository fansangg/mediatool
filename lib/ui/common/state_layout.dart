import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_tool/ui/common/ui_state.dart';
import 'package:media_tool/util/ui_ext.dart';

import '../../generated/assets.dart';
import 'common_widgets.dart';

///@author  fansan
///@version 2023/11/6
///@des     state_layout

class StateLayout extends StatelessWidget {
  final UiState state;
  final Widget child;
  final String emptyMessage;
  final Widget? errorWidget;

  const StateLayout({
    super.key,
    required this.state,
    required this.child,
    this.emptyMessage = "空空如也",
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _buildWidget,
    );
  }

  Widget get _buildWidget {
    switch (state) {
      case UiState.loading:
        return _defaultLoading;
      case UiState.success:
        return child;
      case UiState.failed:
        return errorWidget ?? _defaultError;
      case UiState.empty:
        return commonEmpty(emptyMessage);
    }
  }

  Widget get _defaultLoading {
    return Center(
      child: Card(
        child: SizedBox.square(
          dimension: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(Get.isDarkMode ? Assets.lottieChickenDark : Assets.lottieChicken,width: 80,height: 80),
              12.spacerH,
              const Text("正在加载中..."),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _defaultError {
    return const Center(
      child: Text("Error"),
    );
  }
}
