import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/util/app_util.dart';

///专辑标题
class AlbumHeadTitle extends StatefulWidget {
  final AlbumInfo info;
  final int index;

  const AlbumHeadTitle({Key key, @required this.info, @required this.index})
      : super(key: key);

  @override
  _AlbumHeadTitleState createState() => _AlbumHeadTitleState();
}

class _AlbumHeadTitleState extends State<AlbumHeadTitle> {
  double _op;

  @override
  void initState() {
    super.initState();
    _op = 0.0;

    _opIn();
  }

  _opIn() async {
    await Future.delayed(
        const Duration(milliseconds: 500), () => setState(() => _op = 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(s.style.globalRadius),
          ),
          child: AnimatedOpacity(
            opacity: _op,
            duration: const Duration(milliseconds: 200),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: Lp.w(40)),
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
          ),
        );
      },
    );
  }
}
