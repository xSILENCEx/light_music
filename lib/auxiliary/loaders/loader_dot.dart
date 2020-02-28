import 'dart:math';

import 'package:flutter/material.dart';

import 'dot_type.dart';

class Dot extends StatelessWidget {
  final double size;
  final double radius;
  final Color color;
  final DotType type;
  final Icon icon;

  const Dot({this.radius, this.color, this.type, this.icon, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: type == DotType.icon
          ? Icon(
              icon.icon,
              color: color,
              size: size,
            )
          : new Transform.rotate(
              angle: type == DotType.diamond ? pi / 4 : 0.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                  width: size,
                  height: size,
                  color: color,
                ),
              ),
            ),
    );
  }
}
