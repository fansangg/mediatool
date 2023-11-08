//ignore_for_file: prefer_const_constructors, depend_on_referenced_packages,avoid_print

import 'package:flutter/material.dart';

///@author  fansan
///@version 2023/11/1
///@des     theme_config 

class ThemeConfig{

  static final Color _darkPrimary = Color(0xff242424);
  static final Color _darkOnPrimary = Colors.white.withAlpha(204);
  static final Color _darkSecondary = Color(0xff313131);
  static final Color _darkOnSecondary = Colors.white.withAlpha(204);
  static final Color _darkSurface = Color(0xff242424);
  static final Color _darkOnSurface = Colors.white.withAlpha(204);
  static final Color _darkBackground = Color(0xff111111);
  static final Color _darkOnBackground = Colors.white.withAlpha(204);
  static final Color _darkOnSurfaceVariant = Colors.white.withAlpha(80);

  static final ThemeData dark  = ThemeData(
    colorScheme: ColorScheme(brightness: Brightness.dark, primary: _darkPrimary, onPrimary: _darkOnPrimary, secondary: _darkSecondary, onSecondary: _darkOnSecondary,  background: _darkBackground, onBackground: _darkOnBackground, surface: _darkSurface, onSurface: _darkOnSurface,error: Colors.red.shade900,onError: Colors.red.shade900,onSurfaceVariant:_darkOnSurfaceVariant),
    useMaterial3: true,
  );
}


 

