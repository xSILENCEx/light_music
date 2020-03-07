import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:music_player/music_player.dart';

///播放按钮
class PlayAndPauseBtn extends StatelessWidget {
  const PlayAndPauseBtn({
    Key key,
    @required this.centerSize,
    @required this.indicatorWidth,
  }) : super(key: key);

  ///中心大小
  final double centerSize;

  ///指示器宽度
  final double indicatorWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayMag>(
      builder: (c, play) {
        return SizedBox(
          width: centerSize - indicatorWidth,
          height: centerSize - indicatorWidth,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: play.musicPlayer.state != PlayerState.Playing ? 1.0 : 0.0,
            child: Material(
              borderRadius: BorderRadius.circular(1000),
              color: Theme.of(context).primaryColor,
              child: Icon(Entypo.controller_play),
            ),
          ),
        );
      },
    );
  }
}
