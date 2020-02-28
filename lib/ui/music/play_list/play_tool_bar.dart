import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music_player.dart';

///工具栏
class PlayToolBar extends StatefulWidget {
  const PlayToolBar({Key key, @required this.controller}) : super(key: key);

  final SwiperController controller;

  @override
  _PlayToolBarState createState() => _PlayToolBarState();
}

class _PlayToolBarState extends State<PlayToolBar> {
  ///播放模式页面控制器
  SwiperController _controllerMode;

  @override
  void initState() {
    super.initState();
    _controllerMode = SwiperController()..index = 0;
  }

  @override
  void dispose() {
    _controllerMode.dispose();
    super.dispose();
  }

  ///切换播放模式
  Future<void> _changePlayMode() async {
    print('切换播放模式');
    await _controllerMode.next();
  }

  ///切换到播放列表
  Future<void> _toPlayList() async {
    await widget.controller.next();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _toolLeadings = [
      ///播放模式按钮
      BlocBuilder<StyleBloc, StyleMag>(
        builder: (c, s) {
          return FlatButton(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(s.style.globalRadius / 1.6),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<PlayBloc, PlayMag>(builder: (c, play) {
                    return Swiper(
                      index: play.musicPlayer.mode.index,
                      itemCount: 3,
                      fade: 0.0,
                      controller: _controllerMode,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      loop: true,
                      duration: 800,
                      onTap: null,
                      itemBuilder: (c, index) {
                        final List<IconData> _icons = [
                          SimpleLineIcons.refresh,
                          SimpleLineIcons.reload,
                          SimpleLineIcons.shuffle,
                        ];
                        return Icon(
                          _icons[index],
                          color: Theme.of(context).accentColor,
                          size: Lp.w(50.0),
                        );
                      },
                      onIndexChanged: (index) {
                        BlocProvider.of<PlayBloc>(context)
                            .changePlayMode(PlayMode.values[index]);
                      },
                    );
                  }),
                ),
                SizedBox(
                  width: Lp.w(250),
                  child: Text(
                    AppL.of(context).translate('play_mode'),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color.withOpacity(0.6),
                      fontSize: Lp.w(30.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: _changePlayMode,
          );
        },
      ),

      ///切换到播放列表
      BlocBuilder<StyleBloc, StyleMag>(
        builder: (c, s) {
          return FlatButton(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(s.style.globalRadius / 1.6),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    SimpleLineIcons.playlist,
                    color: Theme.of(context).accentColor,
                    size: Lp.w(50.0),
                  ),
                ),
                SizedBox(
                  width: Lp.w(250),
                  child: Text(
                    AppL.of(context).translate('play_list'),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color.withOpacity(0.6),
                      fontSize: Lp.w(30.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: _toPlayList,
          );
        },
      ),
    ];

    return GridView.builder(
      itemCount: _toolLeadings.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Lp.w(60)),
      itemBuilder: (BuildContext context, int index) {
        return BlocBuilder<StyleBloc, StyleMag>(
          builder: (c, s) {
            return _toolLeadings[index];
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Lp.w(40),
        crossAxisSpacing: Lp.w(40),
        childAspectRatio: 2,
      ),
    );
  }
}
