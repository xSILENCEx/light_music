import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/indicator_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BtnCircleIndicator extends StatelessWidget {
  final double coverSize;

  const BtnCircleIndicator({Key key, @required this.coverSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<IndicatorBloc, IndicatorMag>(
        builder: (c, ind) => CircularPercentIndicator(
          animation: false,
          radius: coverSize,
          lineWidth: 4.0,
          percent: ind.percent,
          progressColor: Theme.of(context).accentColor,
          backgroundColor: Colors.transparent,
          addAutomaticKeepAlive: true,
          animateFromLastPercent: true,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      );
}
