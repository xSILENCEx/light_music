import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/plugins/loaders/color_loader_4.dart';

///水平跳动三点加载动画
class LpLoader4 extends StatelessWidget {
  const LpLoader4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) {
        return ColorLoader4(
          dotOneColor: Theme.of(context).accentColor,
          dotTwoColor: Theme.of(context).textTheme.display4.color,
          dotThreeColor: Theme.of(context).textTheme.display3.color,
          radius: s.style.globalRadius / 10 * 2,
        );
      },
    );
  }
}
