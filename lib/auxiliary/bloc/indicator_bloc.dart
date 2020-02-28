import 'package:flutter_bloc/flutter_bloc.dart';

enum IndicatorEnv { reload }

class IndicatorMag {
  final int indicator;
  final double percent;

  const IndicatorMag({
    this.indicator,
    this.percent,
  });

  IndicatorMag copyWith({
    final int indicator,
    final double percent,
  }) =>
      IndicatorMag(
        indicator: indicator ?? this.indicator,
        percent: percent ?? this.percent,
      );
}

class IndicatorBloc extends Bloc<IndicatorEnv, IndicatorMag> {
  int _indicator = 0;
  double _percent = 0.0;

  @override
  IndicatorMag get initialState =>
      IndicatorMag(indicator: _indicator, percent: _percent);

  ///调整播放进度
  changeIndicator(int i, int current) async {
    this._indicator = i;
    current > 0
        ? this._percent = i.toDouble() / current.toDouble()
        : this._percent = 0;
    this.add(IndicatorEnv.reload);
  }

  @override
  Stream<IndicatorMag> mapEventToState(IndicatorEnv event) async* {
    yield state.copyWith(indicator: _indicator, percent: _percent);
  }
}
