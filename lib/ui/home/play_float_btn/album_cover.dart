import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/app_bloc.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/ui/music/play_list/play_list.dart';

///封面轮播图
class AlbumCover extends StatelessWidget {
  const AlbumCover({Key key, @required this.coverSize}) : super(key: key);

  final double coverSize;

  ///播放暂停
  Future<void> _playPause(LpMusic music, BuildContext context) async {
    await BlocProvider.of<PlayBloc>(context).play(music);
  }

  ///下一曲
  Future<void> _next(BuildContext context) async {
    await BlocProvider.of<PlayBloc>(context).next(isAuto: false);
  }

  ///上一曲
  Future<void> _previous(BuildContext context) async {
    await BlocProvider.of<PlayBloc>(context).previous();
  }

  @override
  Widget build(BuildContext context) {
    ///手势纵坐标
    double _eY = 0.0;

    //手势横坐标
    double _eX = 0.0;

    return ClipOval(
      child: Container(
        width: coverSize - 8,
        height: coverSize - 8,
        color: Theme.of(context).primaryColor,
        child: BlocBuilder<PlayBloc, PlayMag>(
          builder: (c, play) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ///封面图
                Padding(
                  padding: const EdgeInsets.all(0.2),
                  child: ClipOval(
                    child: Lp.pic(
                      context,
                      play.musicPlayer.currentMusic?.coverUrl ?? "",
                      loadSize: Lp.w(30.0),
                    ),
                  ),
                ),

                ///播放与暂停按钮层
                ClipOval(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: BlocProvider.of<PlayBloc>(context)
                                .getAudioPlayerState ==
                            AudioPlayerState.PLAYING
                        ? 0.0
                        : 1.0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      color: Theme.of(context).canvasColor,
                      child: Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),

                ///手势操作层
                BlocBuilder<AppBloc, AppMag>(
                  builder: (c, app) {
                    return GestureDetector(
                      onTap: () =>
                          _playPause(play.musicPlayer.currentMusic, context),

                      //双击进入播放界面
                      onDoubleTap: () {
                        app.appConfig.drawerKey.currentState.openDrawer();
                      },

                      ///上滑展开播放界面
                      onVerticalDragUpdate: (d) => _eY = d.delta.dy,
                      onVerticalDragEnd: (d) async {
                        if (_eY > 0) {
                          print('下');
                        } else {
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const PlayList();
                          }));
                        }
                      },

                      ///左右滑动切歌
                      onHorizontalDragUpdate: (d) => _eX = d.delta.dx,
                      onHorizontalDragEnd: (d) =>
                          _eX > 0 ? _previous(context) : _next(context),

                      //占位
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
