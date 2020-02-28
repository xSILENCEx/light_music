import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';

import 'play_btn.dart';
import 'play_tool_bar.dart';
import 'spin_cover.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key key}) : super(key: key);

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  SwiperController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SwiperController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ///背景图片
        BlocBuilder<PlayBloc, PlayMag>(builder: (c, play) {
          return Lp.pic(context, play.musicPlayer.currentMusic.coverUrl);
        }),

        ///模糊与子控件
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              brightness: Brightness.dark,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: BlocBuilder<PlayBloc, PlayMag>(
                builder: (c, play) {
                  return Text(
                    play.musicPlayer.currentMusic.musicName,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Lp.w(50),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            body: Column(
              children: <Widget>[
                ///歌手
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Lp.w(100)),
                  child: BlocBuilder<PlayBloc, PlayMag>(
                    builder: (c, play) {
                      return Text(
                        play.musicPlayer.currentMusic.getSinger(),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: Lp.w(30),
                        ),
                      );
                    },
                  ),
                ),

                ///旋转封面
                Padding(
                  padding: EdgeInsets.only(top: Lp.w(100)),
                  child: const SpinCover(),
                ),

                ///歌词占位
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: Lp.w(300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '轻听',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: Lp.sp(36),
                        ),
                      ),
                      Text(
                        '歌词功能正在开发',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Lp.sp(36),
                        ),
                      ),
                      Text(
                        '敬请期待',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: Lp.sp(36),
                        ),
                      ),
                    ],
                  ),
                ),

                ///剩余部分为播放控制与播放列表
                Expanded(
                  child: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
                    return Material(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(s.style.globalRadius),
                      ),
                      color: Theme.of(context).canvasColor,
                      child: Swiper.children(
                        controller: _controller,
                        physics: BouncingScrollPhysics(),
                        loop: false,
                        children: <Widget>[
                          _buildController,
                          _buildPlayList(context),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildController {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: <Widget>[
        _backIcon,
        const PlayBtn(),
        PlayToolBar(controller: _controller),
      ],
    );
  }

  Widget get _backIcon {
    return SizedBox(
      height: Lp.w(160),
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Feather.x),
            Text(AppL.of(context).translate('back')),
          ],
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPlayList(BuildContext context) {
    return Column(
      children: <Widget>[
        //播放列表标题
        Material(
          child: ListTile(
            contentPadding: EdgeInsets.only(top: Lp.w(20)),
            leading: Container(
              alignment: Alignment.centerRight,
              width: 50,
              child: Icon(
                Feather.chevron_left,
                color: Theme.of(context).accentColor,
                size: Lp.w(50.0),
              ),
            ),
            title: Text(
              AppL.of(context).translate('play_list'),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _controller.previous(),
          ),
        ),

        ///列表主体
        Expanded(child: PlayListBody()),
      ],
    );
  }
}

class PlayListBody extends StatefulWidget {
  @override
  _PlayListBodyState createState() => _PlayListBodyState();
}

class _PlayListBodyState extends State<PlayListBody> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///滚动到播放歌曲
  _scrollToPosition(int index) async {
    final double _offset = (48 + Lp.w(10)) * index;

    await Future.delayed(Duration(milliseconds: 800), () {});

    _scrollController.jumpTo(_offset);
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<PlayBloc, PlayMag>(
        builder: (c, play) {
          _scrollToPosition(play.musicPlayer.musicIndex);

          return ListView.separated(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            itemCount: play.musicPlayer.playList.length,
            padding:
                EdgeInsets.symmetric(horizontal: Lp.w(60), vertical: Lp.w(20)),
            itemBuilder: (c, index) => PlayListItem(
              index: index,
              music: play.musicPlayer.playList[index],
            ),
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: Lp.w(10)),
          );
        },
      );
}

class PlayListItem extends StatelessWidget {
  const PlayListItem({Key key, @required this.index, @required this.music})
      : super(key: key);

  final int index;

  final LpMusic music;

  ///播放
  Future<void> _playPause(LpMusic music, BuildContext context) async {
    await BlocProvider.of<PlayBloc>(context).play(music);
  }

  @override
  Widget build(BuildContext context) {
    final bool _isSame =
        BlocProvider.of<PlayBloc>(context).isSameWithCurrent(music);
    final bool _isPlaying =
        BlocProvider.of<PlayBloc>(context).getAudioPlayerState ==
            AudioPlayerState.PLAYING;

    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) => ClipRRect(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          color: _isSame
              ? Theme.of(context).accentColor
              : Theme.of(context).canvasColor,
          child: ListTile(
            dense: true,
            title: Text(
              music.musicName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _isSame ? Theme.of(context).primaryColor : null,
              ),
            ),
            trailing: _isSame
                ? Icon(
                    _isPlaying
                        ? Entypo.controller_play
                        : Entypo.controller_paus,
                    color: Theme.of(context).primaryColor,
                    size: Lp.w(50),
                  )
                : null,
            onTap: () => _playPause(music, context),
          ),
        ),
      ),
    );
  }
}
