import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/helpers/local_music_helper.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/ui/home/play_float_btn/play_float_btn.dart';
import 'package:light_player/ui/music/album_page/single_album/album_song_list.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_loader4.dart';
import 'package:light_player/widgets/lp_loader5.dart';

import 'art_tab_item.dart';

class SingerPage extends StatefulWidget {
  const SingerPage({Key key}) : super(key: key);

  @override
  _SingerPageState createState() => _SingerPageState();
}

class _SingerPageState extends State<SingerPage> {
  ///歌手信息列表
  List<ArtistInfo> _singerList;

  String _errorMsg;

  ///歌曲页面控制器
  PageController _pageController;

  ///滚动封面控制器
  ScrollController _scrollController;

  ///tab项的状态
  ListState _tabListState;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _singerList = List<ArtistInfo>();

    _pageController = PageController()
      ..addListener(() {
        final double _offset = _pageController.offset / Lp.screenWidthDp;

        _scrollController.animateTo(
          _offset * Lp.w(500),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCirc,
        );
      });

    _tabListState = ListState.loading;

    _ready();
  }

  ///准备数据
  Future<void> _ready() async {
    try {
      _singerList = await LocalMusicHelper.getAsyncSinger();

      if (_singerList.isEmpty)
        setState(() => _tabListState = ListState.empty);
      else
        setState(() => _tabListState = ListState.list);
    } catch (e) {
      _errorMsg = e.toString();
      setState(() => _tabListState = ListState.error);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (c, b) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              expandedHeight: Lp.screenHeightDp / 2,
              flexibleSpace: FlexibleSpaceBar(
                title: _buildBar,
                centerTitle: true,
                titlePadding: EdgeInsets.zero,
                background: ListView.builder(
                  addAutomaticKeepAlives: false,
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(Lp.w(10), kToolbarHeight,
                      Lp.w(1500), kToolbarHeight * 1.5),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: _singerList.length > 0 ? _singerList.length : 3,
                  itemBuilder: (c, index) => _buildTabItem(index),
                ),
              ),
            ),
          ];
        },
        body: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _singerList.length > 0 ? _singerList.length : 3,
          controller: _pageController,
          itemBuilder: (c, index) => _tabListState == ListState.loading
              ? Center(
                  child: const LpLoader4(),
                )
              : SongList(artistInfo: _singerList[index]),
        ),
      ),
      floatingActionButton: PlayFloatActionBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  ///返回控件
  Widget get _buildBar {
    return BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
      return SizedBox(
        width: Lp.screenWidthDp / 1.5,
        height: kToolbarHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Lp.w(10)),
          child: FlatButton(
            splashColor: Theme.of(context).accentColor,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.symmetric(horizontal: Lp.w(40)),
            color: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(s.style.globalRadius / 1.5),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Feather.chevron_left,
                  size: Lp.w(46),
                ),
                Expanded(
                  child: Text(
                    AppL.of(context).translate('singer'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Lp.sp(60),
                    ),
                  ),
                ),
                Icon(
                  Feather.chevron_right,
                  size: Lp.w(46),
                ),
              ],
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
    });
  }

  ///内容为空时占位
  Widget _buildTabItem(int index) {
    switch (_tabListState) {

      ///列表
      case ListState.list:
        return ArtTabItem(
          index: index,
          info: _singerList[index],
          onTap: () {
            _pageController.jumpToPage(index);
          },
        );
        break;

      ///没有数据
      case ListState.empty:
        return SizedBox(
          width: Lp.w(500),
          child: Padding(
            padding: EdgeInsets.all(Lp.w(20)),
            child: BlocBuilder<StyleBloc, StyleMag>(
              builder: (c, s) {
                return FlatButton(
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s.style.globalRadius),
                  ),
                  child: Opacity(
                    opacity: 0.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Entypo.feather,
                          size: Lp.w(160),
                        ),
                        Text(
                          AppL.of(context).translate('no_data'),
                          style: TextStyle(
                            fontSize: Lp.sp(70),
                            fontWeight: FontWeight.bold,
                            height: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () => null,
                );
              },
            ),
          ),
        );
        break;

      ///出错
      case ListState.error:
        return SizedBox(
          width: Lp.w(500),
          child: Padding(
            padding: EdgeInsets.all(Lp.w(20)),
            child: BlocBuilder<StyleBloc, StyleMag>(
              builder: (c, s) {
                return FlatButton(
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s.style.globalRadius),
                  ),
                  child: Opacity(
                    opacity: 0.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Entypo.feather,
                          size: Lp.w(160),
                        ),
                        Text(
                          AppL.of(context).translate('error'),
                          style: TextStyle(
                            fontSize: Lp.sp(70),
                            fontWeight: FontWeight.bold,
                            height: 2.0,
                          ),
                        ),
                        Text(
                          _errorMsg,
                          style: TextStyle(fontSize: Lp.sp(40)),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () => null,
                );
              },
            ),
          ),
        );
        break;
      default:
        break;
    }

    return SizedBox(
      width: Lp.w(500),
      child: Padding(
        padding: EdgeInsets.all(Lp.w(20)),
        child: BlocBuilder<StyleBloc, StyleMag>(
          builder: (c, s) {
            return FlatButton(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              padding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(s.style.globalRadius),
              ),
              child: const LpLoader5(),
              onPressed: () => null,
            );
          },
        ),
      ),
    );
  }
}
