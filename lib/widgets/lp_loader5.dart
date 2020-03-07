import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/plugins/loaders/color_loader_5.dart';

class LpLoader5 extends StatelessWidget {
  const LpLoader5({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) {
        return ColorLoader5(
          dotOneColor: Theme.of(context).accentColor,
          dotTwoColor: Theme.of(context).textTheme.display4.color,
          dotThreeColor: Theme.of(context).textTheme.display3.color,
          radius: s.style.globalRadius / 10 * 2,
        );
      },
    );
  }
}
