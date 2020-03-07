import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/indicator_bloc.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/plugins/sleek_circular_slider/sleek_circular_slider.dart';

class BtnCircleIndicator extends StatelessWidget {
  final double coverSize;

  const BtnCircleIndicator({Key key, @required this.coverSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayMag>(
      builder: (c, play) {
        return BlocBuilder<IndicatorBloc, IndicatorMag>(
          builder: (c, ind) {
            return SleekCircularSlider(
              duration: 1000,
              appearance: CircularSliderAppearance(
                angleRange: 360,
                startAngle: 90,
                animationEnabled: false,
                size: coverSize,
                customColors: CustomSliderColors(
                  dotColor: Colors.transparent,
                  progressBarColor: Theme.of(context).accentColor,
                  trackColor: Theme.of(context).primaryColor,
                ),
                customWidths: CustomSliderWidths(
                  shadowWidth: 0,
                  trackWidth: 4,
                  progressBarWidth: 4,
                ),
              ),
              min: 0.0,
              max: ind.duration.toDouble(),
              initialValue: ind.indicator.toDouble(),
            );
          },
        );
      },
    );
  }
}
