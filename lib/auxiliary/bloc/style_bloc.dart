//刷新AppBloc的必须枚举
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/objects/lp_style.dart';

enum StyleEve { reload }

///应用配置状态
class StyleMag {
  final LpStyle style;

  const StyleMag({this.style});

  StyleMag copyWith({LpStyle style}) {
    return StyleMag(
      style: style ?? this.style,
    );
  }
}

class StyleBloc extends Bloc<StyleEve, StyleMag> {
  LpStyle _style = LpStyle();

  @override
  StyleMag get initialState => StyleMag(style: _style);

  ///初始化应用风格管理器
  Future<void> init(BuildContext context,
      {Offset offset = const Offset(0, 0)}) async {
    _style.playBtnOffset = offset;
  }

  void changePlayBtnPosition(Offset position) {
    if (this._style.playBtnOffset == position) return;

    this._style.playBtnOffset = position;

    this.add(StyleEve.reload);
  }

  Future<void> changeRadius(double radius) async {
    if (radius != this._style.globalRadius) {
      this._style.globalRadius = radius;
      this.add(StyleEve.reload);
    }
  }

  @override
  Stream<StyleMag> mapEventToState(StyleEve event) async* {
    yield state.copyWith(style: _style);
  }
}
