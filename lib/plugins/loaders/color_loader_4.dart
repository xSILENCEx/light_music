import 'package:flutter/material.dart';

import 'dot_type.dart';
import 'loader_dot.dart';

class ColorLoader4 extends StatefulWidget {
  final Color dotOneColor;
  final Color dotTwoColor;
  final Color dotThreeColor;
  final Duration duration;
  final DotType dotType;
  final Icon dotIcon;
  final double radius;
  final double size;

  const ColorLoader4({
    this.dotOneColor = Colors.redAccent,
    this.dotTwoColor = Colors.green,
    this.dotThreeColor = Colors.blueAccent,
    this.duration = const Duration(milliseconds: 1000),
    this.dotType = DotType.circle,
    this.dotIcon = const Icon(Icons.blur_on),
    this.radius = 2.0,
    this.size = 10,
  });

  @override
  _ColorLoader4State createState() => _ColorLoader4State();
}

class _ColorLoader4State extends State<ColorLoader4>
    with SingleTickerProviderStateMixin {
  Animation<double> _animationDot1;
  Animation<double> _animationDot2;
  Animation<double> _animationDot3;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animationDot1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.80, curve: Curves.ease),
      ),
    );

    _animationDot2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.9, curve: Curves.ease),
      ),
    );

    _animationDot3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.ease),
      ),
    );

    _loading();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///加载动画需要的函数
  _loading() async {
    try {
      await _controller.repeat().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
            animation: _controller,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Dot(
                radius: widget.radius,
                color: widget.dotOneColor,
                type: widget.dotType,
                icon: widget.dotIcon,
                size: widget.size,
              ),
            ),
            builder: (c, child) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  -30 *
                      (_animationDot1.value <= 0.50
                          ? _animationDot1.value
                          : 1.0 - _animationDot1.value),
                ),
                child: child,
              );
            }),
        AnimatedBuilder(
            animation: _controller,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Dot(
                radius: widget.radius,
                color: widget.dotTwoColor,
                type: widget.dotType,
                icon: widget.dotIcon,
                size: widget.size,
              ),
            ),
            builder: (c, child) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  -30 *
                      (_animationDot2.value <= 0.50
                          ? _animationDot2.value
                          : 1.0 - _animationDot2.value),
                ),
                child: child,
              );
            }),
        AnimatedBuilder(
            animation: _controller,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Dot(
                radius: widget.radius,
                color: widget.dotThreeColor,
                type: widget.dotType,
                icon: widget.dotIcon,
                size: widget.size,
              ),
            ),
            builder: (c, child) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  -30 *
                      (_animationDot3.value <= 0.50
                          ? _animationDot3.value
                          : 1.0 - _animationDot3.value),
                ),
                child: child,
              );
            }),
      ],
    );
  }
}
