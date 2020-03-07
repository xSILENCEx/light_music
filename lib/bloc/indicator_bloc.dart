import 'package:flutter_bloc/flutter_bloc.dart';

enum IndicatorEnv { reload }

///播放进度管理器
class IndicatorMag {
  ///进度
  final int indicator;

  ///总长
  final int duration;

  const IndicatorMag({
    this.indicator,
    this.duration,
  });

  IndicatorMag copyWith({
    final int indicator,
    final int duration,
  }) =>
      IndicatorMag(
        indicator: indicator ?? this.indicator,
        duration: duration ?? this.duration,
      );
}

///管理播放进度
class IndicatorBloc extends Bloc<IndicatorEnv, IndicatorMag> {
  int _indicator = 1;
  int _duration = 10;

  @override
  IndicatorMag get initialState => IndicatorMag(indicator: _indicator);

  ///调整播放进度
  /// * [i]当前进度
  /// * [d]总长
  void changeIndicator(int i, int d) async {
    _indicator = i;
    _duration = d;
    this.add(IndicatorEnv.reload);
  }

  @override
  Stream<IndicatorMag> mapEventToState(IndicatorEnv event) async* {
    yield state.copyWith(indicator: _indicator, duration: _duration);
  }
}
