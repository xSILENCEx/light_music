import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/indicator_bloc.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/plugins/sleek_circular_slider/sleek_circular_slider.dart';
import 'package:light_player/auxiliary/util/app_util.dart';

///进度
class PlayPageIndicator extends StatelessWidget {
  const PlayPageIndicator({
    Key key,
    @required this.centerSize,
    @required this.indicatorWidth,
  }) : super(key: key);

  final double centerSize;

  final double indicatorWidth;

  ///将秒转换为时间
  String _transform(int duration) {
    return DateTime.utc(0, 0, 0, 0, 0, duration)
        .toString()
        .split(' ')[1]
        .split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Center(),

        ///总时长
        BlocBuilder<PlayBloc, PlayMag>(
          builder: (c, play) => Text(
            _transform(play.musicPlayer.currentMusic.duration),
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
              fontSize: Lp.sp(40),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        ///进度条
        JustIndicator(centerSize: centerSize, indicatorWidth: indicatorWidth),

        ///进度时间
        BlocBuilder<IndicatorBloc, IndicatorMag>(
          builder: (c, ind) => Text(
            _transform(ind.indicator),
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
              fontSize: Lp.sp(40),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Center(),
      ],
    );
  }
}

///进度条
class JustIndicator extends StatefulWidget {
  const JustIndicator({
    Key key,
    @required this.centerSize,
    @required this.indicatorWidth,
  }) : super(key: key);

  final double centerSize;

  final double indicatorWidth;

  @override
  _JustIndicatorState createState() => _JustIndicatorState();
}

class _JustIndicatorState extends State<JustIndicator> {
  ///是否正在拖动进度条
  bool _isDrag = false;

  ///精确进度
  double _progress = 0.0;

  ///跳转进度
  Future<void> _seekTo(int s) async =>
      await BlocProvider.of<PlayBloc>(context).seekTo(context, s);

  ///将秒转换为时间
  String _transform(int duration) => DateTime.utc(0, 0, 0, 0, 0, duration)
      .toString()
      .split(' ')[1]
      .split('.')[0];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndicatorBloc, IndicatorMag>(builder: (c, ind) {
      if (!_isDrag) _progress = ind.indicator.toDouble();

      return SleekCircularSlider(
        duration: 800,
        appearance: CircularSliderAppearance(
          angleRange: 360.0,
          startAngle: 90.0,
          animationEnabled: false,
          size: widget.centerSize + Lp.w(100.0),
          customColors: CustomSliderColors(
            dotColor: Theme.of(context).primaryColor,
            progressBarColor: Theme.of(context).accentColor,
            trackColor: Theme.of(context).primaryColor,
          ),
          customWidths: CustomSliderWidths(
            shadowWidth: 0.0,
            trackWidth: widget.indicatorWidth,
            progressBarWidth: widget.indicatorWidth,
          ),
        ),
        min: 0.0,
        max: BlocProvider.of<PlayBloc>(context)
            .getCurrentMusic
            .duration
            .toDouble(),
        initialValue: _progress,

        ///开始拖动进度条
        onChangeStart: (double startValue) => _isDrag = true,

        ///结束拖动进度条
        onChangeEnd: (double endValue) async {
          _isDrag = false;

          await _seekTo(endValue.toInt());
        },

        ///中心控件
        innerWidget: (v) {
          return _isDrag
              ? Padding(
                  padding: EdgeInsets.all(widget.indicatorWidth),
                  child: ClipOval(
                    child: Container(
                      alignment: Alignment.center,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        _transform(v.toInt()),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Lp.sp(36),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                )
              : Center();
        },
      );
    });
  }
}
