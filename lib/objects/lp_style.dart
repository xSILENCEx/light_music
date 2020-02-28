import 'dart:ui';

///控制应用的一些风格
class LpStyle {
  ///全局圆角大小
  double globalRadius;

  ///全局字体大小
  double globalFontSize;

  ///悬浮按钮位置
  Offset playBtnOffset;

  LpStyle({
    this.globalRadius = 10.0,
    this.globalFontSize = 20,
    this.playBtnOffset = const Offset(0, 0),
  });
}
