import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/util/app_util.dart';

import 'left_menu.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: Lp.w(40),
          bottom: Lp.w(40),
          top: MediaQuery.of(context).padding.top + Lp.w(40),
        ),
        child: BlocBuilder<StyleBloc, StyleMag>(
            builder: (c, s) => Material(
                  clipBehavior: Clip.antiAlias,
                  animationDuration: const Duration(seconds: 1),
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(s.style.globalRadius),
                  child: SizedBox(
                    width: Lp.w(700),
                    child: const LeftMenu(),
                  ),
                )),
      );
}
