import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_image.dart';
import 'package:music_player/music_player.dart';

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
          return LpImage(play.musicPlayer.data.iconUri);
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
                    play.musicPlayer.data.title,
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
                        play.musicPlayer.data.subtitle,
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

  ///跳转到播放歌曲
  _scrollToPosition(BuildContext context) async {
    final int _index = BlocProvider.of<PlayBloc>(context).getIndex;

    final double _offset = (48 + Lp.w(10)) * _index;
    Future.delayed(const Duration(milliseconds: 200),
        () => _scrollController.jumpTo(_offset));
  }

  @override
  Widget build(BuildContext context) {
    _scrollToPosition(context);

    return ListView.separated(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      itemCount:
          BlocProvider.of<PlayBloc>(context).getPlayer.queue.queue.length,
      padding: EdgeInsets.symmetric(horizontal: Lp.w(60), vertical: Lp.w(20)),
      itemBuilder: (c, index) => PlayListItem(
        index: index,
        music: BlocProvider.of<PlayBloc>(context).getPlayer.queue.queue[index],
        playQueue: BlocProvider.of<PlayBloc>(context).getPlayer.queue,
      ),
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: Lp.w(10)),
    );
  }
}

class PlayListItem extends StatelessWidget {
  const PlayListItem(
      {Key key,
      @required this.index,
      @required this.music,
      @required this.playQueue})
      : super(key: key);

  ///索引
  final int index;

  ///当前界面的音乐列表
  final PlayQueue playQueue;

  ///音乐信息
  final MusicMetadata music;

  ///播放
  Future<void> _playPause(BuildContext context) async {
    await BlocProvider.of<PlayBloc>(context)
        .play(music: music, playQueue: playQueue);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(s.style.globalRadius * 0.8),
          child: BlocBuilder<PlayBloc, PlayMag>(
            builder: (pc, play) {
              final bool _isPlaying = BlocProvider.of<PlayBloc>(context)
                      .getPlayer
                      .playbackState
                      .state ==
                  PlayerState.Playing;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                color: play.musicPlayer.data.mediaId == music.mediaId
                    ? Theme.of(context).accentColor
                    : Theme.of(context).canvasColor,
                child: ListTile(
                  dense: true,
                  title: Text(
                    music.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: play.musicPlayer.data.mediaId == music.mediaId
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                  ),
                  trailing: play.musicPlayer.data.mediaId == music.mediaId
                      ? Icon(
                          _isPlaying
                              ? Entypo.controller_play
                              : Entypo.controller_paus,
                          color: Theme.of(context).primaryColor,
                          size: Lp.w(50),
                        )
                      : null,
                  onTap: () => _playPause(context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
