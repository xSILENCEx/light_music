import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/helpers/local_music_helper.dart';
import 'package:light_player/auxiliary/loaders/color_loader_5.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';

import 'single_album/single_album.dart';

//专辑
class AlbumBody extends StatefulWidget {
  const AlbumBody({Key key}) : super(key: key);

  @override
  _AlbumBodyState createState() => _AlbumBodyState();
}

class _AlbumBodyState extends State<AlbumBody> {
  ///控件透明度
  double _op;

  ///控件偏移量
  double _position;

  ///页面状态
  ListState _state;

  ///专辑列表
  List<AlbumInfo> _listAlbum;

  @override
  void initState() {
    super.initState();
    _op = 0.0;
    _position = -80.0;
    _state = ListState.loading;

    _listAlbum = List<AlbumInfo>();

    _opIn();
    _readyAlbum();
  }

  ///头部标题与底部视图逐渐出现
  _opIn() async {
    await Future.delayed(
        const Duration(milliseconds: 800),
        () => setState(() {
              _op = 1.0;
              _position = 0.0;
            }));
  }

  ///准备专辑信息
  _readyAlbum() async {
    try {
      ///专辑信息列表
      _listAlbum = await LocalMusicHelper.getAsyncAlbums();

      if (_listAlbum.isEmpty) {
        print('没有专辑数据');
        setState(() {
          _state = ListState.empty;
        });
      } else {
        setState(() {
          _state = ListState.list;
        });
      }
    } catch (e) {
      print('获取专辑失败:$e');

      setState(() {
        _state = ListState.error;
      });
    }
  }

  ///打开指定id专辑
  _openAlbum(AlbumInfo info, int index) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SingleAlbum(
          index: index,
          info: info,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: _position,
      curve: Curves.easeOutExpo,
      duration: const Duration(milliseconds: 800),
      child: SizedBox(
        width: Lp.screenWidthDp,
        height: Lp.screenHeightDp * 0.62,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _op,
          child: Padding(
            padding: EdgeInsets.only(bottom: Lp.w(100)),
            child: Theme(
              data: ThemeData(
                textTheme: TextTheme(),
              ),
              child: Material(
                color: Colors.transparent,
                child: Swiper(
                  itemCount: _listAlbum.length > 0 ? _listAlbum.length : 3,
                  scale: 0.5,
                  viewportFraction: 0.7,
                  pagination: SwiperPagination(
                    builder: SwiperPagination.fraction,
                    margin: EdgeInsets.only(top: 20),
                  ),
                  itemBuilder: (c, index) => _albumItem(index),
                  onIndexChanged: (index) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///构建专辑Item
  Widget _albumItem(int index) {
    switch (_state) {

      ///正在加载
      case ListState.loading:
        return BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(s.style.globalRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.1),
                child: ColorLoader5(
                  dotOneColor: Theme.of(context).accentColor,
                  dotTwoColor: Theme.of(context).textTheme.display4.color,
                  dotThreeColor: Theme.of(context).textTheme.display3.color,
                  radius: s.style.globalRadius / 10 * 2,
                ),
              ),
            ),
          );
        });
        break;

      ///显示列表
      case ListState.list:
        final AlbumInfo _info = _listAlbum[index];

        return Padding(
          padding: EdgeInsets.only(bottom: Lp.w(160)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(s.style.globalRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.all(Lp.w(80)),
                child: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(s.style.globalRadius),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.0,
                          child:
                              BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
                            return Hero(
                              tag: 'cover$index',
                              child: FlatButton(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      s.style.globalRadius * 0.8),
                                ),
                                padding: EdgeInsets.zero,
                                child: Lp.pic(context, _info.albumArt),
                                onPressed: () => _openAlbum(_info, index),
                              ),
                            );
                          }),
                        ),
                        Text(
                          _info.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: Lp.sp(46),
                            fontWeight: FontWeight.bold,
                            height: 3.0,
                          ),
                        ),
                        Text(
                          _info.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Lp.sp(36),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            AppL.of(context).translate('album_id') +
                                ':${_info.id}',
                            style: TextStyle(color: Colors.white54),
                          ),
                          subtitle: Text(
                            AppL.of(context).translate('num_of_tracks') +
                                ':${_info.numberOfSongs}',
                            style: TextStyle(color: Colors.white54),
                          ),
                          trailing: AspectRatio(
                            aspectRatio: 1.0,
                            child: Icon(
                              Feather.play_circle,
                              color: Colors.white54,
                            ),
                          ),
                          onTap: () => _openAlbum(_info, index),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
        break;

      ///内容为空
      case ListState.empty:
        return Center(
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

      ///加载出错
      case ListState.error:
        return Center(
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
              ],
            ),
          ),
        );
        break;
      default:
        break;
    }

    return null;
  }
}
