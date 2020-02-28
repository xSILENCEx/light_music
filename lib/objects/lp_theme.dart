import 'package:flutter/material.dart';

///默认主色调
const int purePrimaryValue = 0xff6395ff;

///自然主题
const int naturePrimaryValue = 0xff56a36c;

///夜间模式主色调
const int nightPrimaryValue = 0xffad6bce;

///粉色主题主色调
const int pinkPrimaryValue = 0xfff45c93;

///冰蓝主色调
const int coolPrimaryValue = 0xff556fb5;

///默认主题颜色
const MaterialColor _mainThemeColor = MaterialColor(
  purePrimaryValue,
  <int, Color>{
    50: Color(0xff93d4ff),
    100: Color(0xff70c5ff),
    200: Color(0xff59bcff),
    300: Color(0xff44b4ff),
    400: Color(0xff32adff),
    500: Color(purePrimaryValue),
    600: Color(0xff0091f2),
    700: Color(0xff0086e0),
    800: Color(0xff047ac9),
    900: Color(0xff0f6faf),
  },
);

///自然主题颜色
const MaterialColor _natureThemeColor = MaterialColor(
  purePrimaryValue,
  <int, Color>{
    50: Color(0xff66dd87),
    100: Color(0xff66d686),
    200: Color(0xff62c97f),
    300: Color(0xff5ec17a),
    400: Color(0xff59af72),
    500: Color(naturePrimaryValue),
    600: Color(0xff47895a),
    700: Color(0xff3e7c50),
    800: Color(0xff2c633c),
    900: Color(0xff1a4f29),
  },
);

///夜间主题颜色
const MaterialColor _nightThemeColor = MaterialColor(
  coolPrimaryValue,
  <int, Color>{
    50: Color(0xffcc76f7),
    100: Color(0xffc673ef),
    200: Color(0xffbf6de8),
    300: Color(0xffbb70e0),
    400: Color(0xffb672d8),
    500: Color(nightPrimaryValue), //0xffad6bce
    600: Color(0xff995bb7),
    700: Color(0xff864ea3),
    800: Color(0xff7b4696),
    900: Color(0xff6c3b84),
  },
);

///粉红主题颜色
const MaterialColor _pinkThemeColor = MaterialColor(
  pinkPrimaryValue,
  <int, Color>{
    50: Color(0xffffe8e8),
    100: Color(0xffffd1d8),
    200: Color(0xffffb9cb),
    300: Color(0xffffa2c5),
    400: Color(0xffff8ba8),
    500: Color(pinkPrimaryValue),
    600: Color(0xffff7485),
    700: Color(0xffff5d85),
    800: Color(0xffff468b),
    900: Color(0xffff2e63),
  },
);

///冰蓝主题颜色
const MaterialColor _coolThemeColor = MaterialColor(
  coolPrimaryValue,
  <int, Color>{
    50: Color(0xff9db6fa),
    100: Color(0xff7693e0),
    200: Color(0xff6c89d6),
    300: Color(0xff6480cb),
    400: Color(0xff5e79c1),
    500: Color(coolPrimaryValue),
    600: Color(0xff4861a0),
    700: Color(0xff3b5391),
    800: Color(0xff31477f),
    900: Color(0xff1f315e),
  },
);

class LpTheme {
  ///主题表编号
  final int code;

  ///主题主色调
  final Color mainColor;

  ///开屏颜色
  final Color startScreen;

  ///主题装饰颜色
  final Color dottedColor;

  ///主题整体背景色
  final Color canvasColor;

  ///主题警告色
  final Color warningColor;

  ///主题底色
  final MaterialColor theme;

  ///状态栏颜色模式
  final Brightness brightness;

  ///图标颜色
  final Color iconColor;

  ///是否跟随系统变化
  bool themeFollowSystem;

  LpTheme(
      {this.code = 0,
      this.mainColor = const Color(0xffffffff),
      this.startScreen = const Color(0xff6395ff),
      this.dottedColor = const Color(0xff826ad1),
      this.canvasColor,
      this.warningColor,
      this.theme,
      this.brightness,
      this.iconColor = const Color(0xff111111),
      this.themeFollowSystem = true});
}

LpTheme pureTheme = LpTheme(
  code: 0,
  mainColor: const Color(0xffffffff),
  startScreen: const Color(0xff6395ff),
  dottedColor: const Color(0xff826ad1),
  canvasColor: const Color(0xfff4f4f4),
  warningColor: const Color(0xffef5350),
  theme: _mainThemeColor,
  brightness: Brightness.light,
);

LpTheme natureTheme = LpTheme(
  code: 1,
  mainColor: const Color(0xffffffff),
  startScreen: const Color(0xff56a36c),
  dottedColor: const Color(0xff826ad1),
  canvasColor: const Color(0xfff4f4f4),
  warningColor: const Color(0xffef5350),
  theme: _natureThemeColor,
  brightness: Brightness.light,
);

LpTheme nightTheme = LpTheme(
  code: 2,
  mainColor: const Color(0xff000111),
  startScreen: const Color(0xff111111),
  dottedColor: const Color(0xff447bbf),
  canvasColor: const Color(0xff353535),
  warningColor: const Color(0xffef5350),
  iconColor: const Color(0xffad6bce),
  theme: _nightThemeColor,
  brightness: Brightness.dark,
);

///粉色主题
LpTheme pinkTheme = LpTheme(
  code: 3,
  mainColor: const Color(0xffffffff),
  startScreen: const Color(0xfff45c93),
  dottedColor: const Color(0xffab5cd6),
  canvasColor: const Color(0xfff4f4f4),
  warningColor: const Color(0xffef5350),
  theme: _pinkThemeColor,
  brightness: Brightness.light,
);

///深蓝主题
LpTheme coolTheme = LpTheme(
  code: 4,
  mainColor: const Color(0xffffffff),
  startScreen: const Color(0xff556fb5),
  dottedColor: const Color(0xff666666),
  canvasColor: const Color(0xfff4f4f4),
  warningColor: const Color(0xffef5350),
  theme: _coolThemeColor,
  brightness: Brightness.light,
);
