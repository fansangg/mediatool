//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

///@author  fansan
///@version 2023/11/1
///@des     translationx

import 'package:flutter/material.dart';

class TranslationX extends StatefulWidget {
  TranslationX({super.key, required this.axisDirection, required this.child, required this.animationController}) : super() {
    switch (axisDirection) {
      case AxisDirection.left:
        _tween = Tween(begin: Offset(-2, 0), end: Offset(0, 0));
      case AxisDirection.right:
        _tween = Tween(begin: Offset(2, 0), end: Offset(0, 0));
      default:
        _tween = Tween(begin: Offset(2, 0), end: Offset(0, 0));
    }
  }

  final Widget child;
  final AxisDirection axisDirection;
  late final Tween<Offset> _tween;
  final AnimationController animationController;

  @override
  State<TranslationX> createState() => _TranslationXState();
}

class _TranslationXState extends State<TranslationX> with SingleTickerProviderStateMixin {
  late final Animation<Offset> _animation;

  @override
  void initState() {
    _animation = widget._tween.animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return FractionalTranslation(
          translation: _animation.value,
          child: child,
        );
      },
    );
  }
}
