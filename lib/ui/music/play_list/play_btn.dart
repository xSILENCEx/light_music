import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';

import 'play_and_pause_btn.dart';
import 'play_page_indicator.dart';

///播放界面的播放按钮
class PlayBtn extends StatefulWidget {
  const PlayBtn({Key key}) : super(key: key);

  @override
  _PlayBtnState createState() => _PlayBtnState();
}

class _PlayBtnState extends State<PlayBtn> {
  double _eX = 0.0;

  ///播放暂停
  Future<void> _playPause(LpMusic music) async {
    await BlocProvider.of<PlayBloc>(context).play(music);
  }

  ///下一曲
  Future<void> _next() async {
    await BlocProvider.of<PlayBloc>(context).next(isAuto: false);
  }

  ///上一曲
  Future<void> _previous() async {
    await BlocProvider.of<PlayBloc>(context).previous();
  }

  @override
  Widget build(BuildContext context) {
    ///中心大小
    final double _centerSize = Lp.w(360);

    ///指示器宽度
    final double _indicatorWidth = Lp.w(100);

    return BlocBuilder<PlayBloc, PlayMag>(
      builder: (c, play) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ///播放与暂停指示器
            ClipOval(
              child: Container(
                width: _centerSize,
                height: _centerSize,
                color: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                child: Icon(Entypo.controller_paus),
              ),
            ),

            ///播放暂停按钮
            PlayAndPauseBtn(
              centerSize: _centerSize,
              indicatorWidth: _indicatorWidth,
            ),

            ///进度条
            PlayPageIndicator(
              centerSize: _centerSize,
              indicatorWidth: _indicatorWidth,
            ),

            ///手势控制
            ClipOval(
              child: SizedBox(
                width: _centerSize,
                height: _centerSize,
                child: GestureDetector(
                  onTap: () => _playPause(play.musicPlayer.currentMusic),

                  ///左滑右滑切歌
                  onHorizontalDragUpdate: (d) {
                    _eX = d.delta.dx;
                  },
                  onHorizontalDragEnd: (d) async {
                    _eX > 0 ? _previous() : _next();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
