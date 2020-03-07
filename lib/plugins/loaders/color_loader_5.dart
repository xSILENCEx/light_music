import 'package:flutter/material.dart';

import 'dot_type.dart';
import 'loader_dot.dart';

class ColorLoader5 extends StatefulWidget {
  final Color dotOneColor;
  final Color dotTwoColor;
  final Color dotThreeColor;
  final Duration duration;
  final DotType dotType;
  final Icon dotIcon;
  final double radius;
  final double size;

  const ColorLoader5(
      {this.dotOneColor = Colors.redAccent,
      this.dotTwoColor = Colors.green,
      this.dotThreeColor = Colors.blueAccent,
      this.duration = const Duration(milliseconds: 1000),
      this.dotType = DotType.circle,
      this.dotIcon = const Icon(Icons.blur_on),
      this.radius = 2,
      this.size = 10});

  @override
  _ColorLoader5State createState() => _ColorLoader5State();
}

class _ColorLoader5State extends State<ColorLoader5>
    with SingleTickerProviderStateMixin {
  Animation<double> animationDot1;
  Animation<double> animationDot2;
  Animation<double> animationDot3;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    animationDot1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.70, curve: Curves.linear),
      ),
    );

    animationDot2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.linear),
      ),
    );

    animationDot3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.linear),
      ),
    );

    _loading();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _loading() async {
    try {
      await _controller.repeat().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
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
                return Opacity(
                  opacity: animationDot1.value <= 0.4
                      ? 2.5 * animationDot1.value
                      : (animationDot1.value > 0.40 &&
                              animationDot1.value <= 0.60)
                          ? 1.0
                          : 2.5 - (2.5 * animationDot1.value),
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
                return Opacity(
                  opacity: animationDot2.value <= 0.4
                      ? 2.5 * animationDot2.value
                      : (animationDot2.value > 0.40 &&
                              animationDot2.value <= 0.60)
                          ? 1.0
                          : 2.5 - (2.5 * animationDot2.value),
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
                return Opacity(
                  opacity: animationDot3.value <= 0.4
                      ? 2.5 * animationDot3.value
                      : (animationDot3.value > 0.40 &&
                              animationDot3.value <= 0.60)
                          ? 1.0
                          : 2.5 - (2.5 * animationDot3.value),
                  child: child,
                );
              }),

          // Opacity(
          //   opacity: animation_1.value <= 0.4
          //       ? 2.5 * animation_1.value
          //       : (animation_1.value > 0.40 && animation_1.value <= 0.60)
          //           ? 1.0
          //           : 2.5 - (2.5 * animation_1.value),
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Dot(
          //       radius: widget.radius,
          //       color: widget.dotOneColor,
          //       type: widget.dotType,
          //       icon: widget.dotIcon,
          //       size: widget.size,
          //     ),
          //   ),
          // ),
          // Opacity(
          //   opacity: (animation_2.value <= 0.4
          //       ? 2.5 * animation_2.value
          //       : (animation_2.value > 0.40 && animation_2.value <= 0.60)
          //           ? 1.0
          //           : 2.5 - (2.5 * animation_2.value)),
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Dot(
          //       radius: widget.radius,
          //       color: widget.dotTwoColor,
          //       type: widget.dotType,
          //       icon: widget.dotIcon,
          //       size: widget.size,
          //     ),
          //   ),
          // ),
          // Opacity(
          //   opacity: (animation_3.value <= 0.4
          //       ? 2.5 * animation_3.value
          //       : (animation_3.value > 0.40 && animation_3.value <= 0.60)
          //           ? 1.0
          //           : 2.5 - (2.5 * animation_3.value)),
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Dot(
          //       radius: widget.radius,
          //       color: widget.dotThreeColor,
          //       type: widget.dotType,
          //       icon: widget.dotIcon,
          //       size: widget.size,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
