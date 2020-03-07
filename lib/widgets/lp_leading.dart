import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/util/app_util.dart';

///通用返回按钮
class LpLeading extends StatelessWidget {
  const LpLeading({Key key, this.iconColor, this.size}) : super(key: key);
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Feather.chevron_left,
        size: size ?? Lp.w(60.0),
        color: iconColor,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
