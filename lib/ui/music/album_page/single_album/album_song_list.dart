import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/helpers/local_music_helper.dart';
import 'package:light_player/auxiliary/loaders/color_loader_4.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';

import '../../music_item.dart';

//音乐列表
class SongList extends StatefulWidget {
  ///专辑信息
  final AlbumInfo albumInfo;

  final ArtistInfo artistInfo;

  const SongList({
    Key key,
    this.albumInfo,
    this.artistInfo,
  }) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  ///列表状态
  ListState _state;

  ///音乐列表
  List<LpMusic> _musicList;

  ///错误信息
  String _errorInfo;

  @override
  void initState() {
    super.initState();

    _state = ListState.loading;

    _musicList = List<LpMusic>();

    _ready();
  }

  _ready() async {
    try {
      if (widget.albumInfo != null) {
        _musicList =
            await LocalMusicHelper.getAsyncSongsFromAlbum(widget.albumInfo.id);
      } else if (widget.artistInfo != null) {
        _musicList =
            await LocalMusicHelper.getAsyncSingerSongs(widget.artistInfo.name);
      } else {
        throw ("albumInfo and artistInfo are null");
      }

      if (_musicList.isEmpty) {
        setState(() => _state = ListState.empty);
      } else {
        setState(() => _state = ListState.list);
      }
    } catch (e) {
      _errorInfo = e.toString();
      print('error:$e');
      setState(() => _state = ListState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {

      ///列表
      case ListState.list:
        return widget.artistInfo == null
            ? SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: Lp.w(40), vertical: Lp.w(80)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        MusicItem(
                          index: index,
                          currentMusicList: _musicList,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    childCount: _musicList.length,
                    addAutomaticKeepAlives: false,
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: Lp.w(40)),
                physics: BouncingScrollPhysics(),
                itemCount: _musicList.length,
                itemBuilder: (context, index) => MusicItem(
                  index: index,
                  currentMusicList: _musicList,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              );
        break;

      ///没有数据
      case ListState.empty:
        return widget.artistInfo == null
            ? SliverFillRemaining(
                child: Center(
                  child: Opacity(
                    opacity: 0.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Entypo.feather,
                          size: Lp.w(200),
                        ),
                        Text(
                          AppL.of(context).translate('no_data'),
                          style: TextStyle(
                            fontSize: Lp.sp(80),
                            fontWeight: FontWeight.bold,
                            height: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Entypo.feather,
                        size: Lp.w(200),
                      ),
                      Text(
                        AppL.of(context).translate('no_data'),
                        style: TextStyle(
                          fontSize: Lp.sp(80),
                          fontWeight: FontWeight.bold,
                          height: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
        break;

      ///出错
      case ListState.error:
        return widget.artistInfo == null
            ? SliverFillRemaining(
                child: Center(
                  child: Opacity(
                    opacity: 0.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Entypo.feather,
                          size: Lp.w(200),
                        ),
                        Text(
                          AppL.of(context).translate('error'),
                          style: TextStyle(
                            fontSize: Lp.sp(80),
                            fontWeight: FontWeight.bold,
                            height: 2.0,
                          ),
                        ),
                        Text(
                          _errorInfo,
                          style: TextStyle(fontSize: Lp.sp(40)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Entypo.feather,
                        size: Lp.w(200),
                      ),
                      Text(
                        AppL.of(context).translate('error'),
                        style: TextStyle(
                          fontSize: Lp.sp(80),
                          fontWeight: FontWeight.bold,
                          height: 2.0,
                        ),
                      ),
                      Text(
                        _errorInfo,
                        style: TextStyle(fontSize: Lp.sp(40)),
                      ),
                    ],
                  ),
                ),
              );
        break;
      default:
        break;
    }

    return widget.artistInfo == null
        ? SliverFillRemaining(
            child: Center(
              child: BlocBuilder<StyleBloc, StyleMag>(
                builder: (c, s) {
                  return ColorLoader4(
                    dotOneColor: Theme.of(context).accentColor,
                    dotTwoColor: Theme.of(context).textTheme.display4.color,
                    dotThreeColor: Theme.of(context).textTheme.display3.color,
                    radius: s.style.globalRadius / 10 * 2,
                  );
                },
              ),
            ),
          )
        : Center(
            child: BlocBuilder<StyleBloc, StyleMag>(
              builder: (c, s) {
                return ColorLoader4(
                  dotOneColor: Theme.of(context).accentColor,
                  dotTwoColor: Theme.of(context).textTheme.display4.color,
                  dotThreeColor: Theme.of(context).textTheme.display3.color,
                  radius: s.style.globalRadius / 10 * 2,
                );
              },
            ),
          );
  }
}
