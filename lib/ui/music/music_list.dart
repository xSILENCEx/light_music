import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/app_bloc.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/helpers/follow_music_helper.dart';
import 'package:light_player/helpers/local_music_helper.dart';
import 'package:light_player/objects/lp_config.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_empty_widget.dart';
import 'package:light_player/widgets/lp_error_widget.dart';
import 'package:light_player/widgets/lp_loader4.dart';
import 'package:music_player/music_player.dart';

import 'music_item.dart';

class MusicList extends StatefulWidget {
  const MusicList({Key key, @required this.musicType}) : super(key: key);

  ///音乐类型，根据类型可以对数据进行分批操作
  final MusicType musicType;

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList>
    with AutomaticKeepAliveClientMixin<MusicList> {
  ///当前页面的列表数据
  List<LpMusic> _musicList;

  ///列表状态
  ListState _listState;

  @override
  void initState() {
    super.initState();
    _musicList = List<LpMusic>();

    _listState = ListState.loading;

    _initPage();
  }

  ///初始化当前页面
  Future<void> _initPage({bool isRefresh = false}) async {
    ///获取文件
    ///展示列表
    ///更新播放列表

    try {
      switch (widget.musicType) {
        case MusicType.local:
          _musicList = await LocalMusicHelper.getLocalMusicList();
          if (!isRefresh && _musicList.isNotEmpty) {
            await BlocProvider.of<PlayBloc>(context).initFirstSong(
              _musicList[0],
              PlayQueue(
                queueId: "${widget.musicType}List",
                queueTitle: "Default playlist",
                queue: _musicList,
              ),
            );
          }
          break;
        case MusicType.follow:
          _musicList = await QQMusicHelper.getRecommendQQMusic();
          break;
        default:
          break;
      }

      ///延迟800ms刷新，防止UI卡顿
      if (isRefresh) {
        Future.delayed(Duration(milliseconds: 800), () {
          if (_musicList.isEmpty)
            setState(() => _listState = ListState.empty);
          else
            setState(() => _listState = ListState.list);
          print('刷新完成');
        });
      } else {
        if (_musicList.isEmpty)
          setState(() => _listState = ListState.empty);
        else
          setState(() => _listState = ListState.list);
      }
    } catch (e) {
      setState(() => _listState = ListState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AppBloc, AppMag>(
      builder: (c, app) {
        return _buildPage(app.appConfig);
      },
    );
  }

  ///构建不同状态的页面
  Widget _buildPage(AppConfig appConfig) {
    final List<Widget> _pages = <Widget>[
      ///正在加载页面
      Center(
        child: const LpLoader4(),
      ),

      ///常规页面
      EasyRefresh(
        onRefresh: () async => await _initPage(isRefresh: true),
        header: _headerAndFooter(),
        onLoad: null,
        footer: null,
        child: _listBody,
      ),

      ///空页面
      EasyRefresh(
        topBouncing: false,
        bottomBouncing: false,
        onRefresh: () async => await _initPage(isRefresh: true),
        header: _headerAndFooter(),
        onLoad: null,
        footer: null,
        emptyWidget: const EmptyWidget(),
        child: const Center(),
      ),

      ///未知错误页面
      EasyRefresh(
        topBouncing: false,
        bottomBouncing: false,
        onRefresh: () async => await _initPage(isRefresh: true),
        header: _headerAndFooter(),
        onLoad: null,
        footer: null,
        emptyWidget: const LpErrorWidget(),
        child: const Center(),
      ),
    ];

    return _pages[_listState.index];
  }

  ///构建音乐列表主体
  Widget get _listBody {
    return ListView.separated(
      itemCount: _musicList.length + 1,
      shrinkWrap: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(Lp.w(40)),
      itemBuilder: (c, index) {
        if (index == _musicList.length)
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Lp.w(80)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Entypo.feather,
                      size: Lp.w(90),
                      color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                    ),
                    SizedBox(width: Lp.w(20.0)),
                    Text(
                      "Light Player",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Lp.sp(60.0),
                        color:
                            Theme.of(context).iconTheme.color.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                Text(
                  'https://github.com/xSILENCEx/light_player',
                  style: TextStyle(
                    fontSize: Lp.sp(30.0),
                    color: Theme.of(context).iconTheme.color.withOpacity(0.3),
                    height: 3.0,
                  ),
                ),
              ],
            ),
          );
        return MusicItem(
          index: index,
          playQueue: PlayQueue(
            queueId: "${widget.musicType}List",
            queueTitle: "Default playlist",
            queue: _musicList,
          ),
          music: _musicList[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }

  ///构建头部和底部动画
  dynamic _headerAndFooter({bool isHeader = true}) {
    return isHeader
        ? CustomHeader(
            extent: Lp.w(160.0),
            triggerDistance: Lp.w(200),
            headerBuilder: (
              BuildContext context,
              RefreshMode refreshState,
              double pulledExtent,
              double refreshTriggerPullDistance,
              double refreshIndicatorExtent,
              AxisDirection axisDirection,
              bool float,
              Duration completeDuration,
              bool enableInfiniteRefresh,
              bool success,
              bool noMore,
            ) {
              return refreshState.index == 0
                  ? Center()
                  : Padding(
                      padding: EdgeInsets.only(top: Lp.w(50.0)),
                      child: const LpLoader4(),
                    );
            },
          )
        : CustomFooter(
            extent: Lp.w(400),
            triggerDistance: Lp.w(500),
            footerBuilder: (BuildContext context,
                    LoadMode loadState,
                    double pulledExtent,
                    double loadTriggerPullDistance,
                    double loadIndicatorExtent,
                    AxisDirection axisDirection,
                    bool float,
                    Duration completeDuration,
                    bool enableInfiniteLoad,
                    bool success,
                    bool noMore) =>
                Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Entypo.feather,
                      size: Lp.w(90),
                      color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                    ),
                    SizedBox(width: Lp.w(20.0)),
                    Text(
                      "Light Player",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Lp.sp(60.0),
                        color:
                            Theme.of(context).iconTheme.color.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                Text(
                  'https://github.com/xSILENCEx/light_player',
                  style: TextStyle(
                    fontSize: Lp.sp(30.0),
                    color: Theme.of(context).iconTheme.color.withOpacity(0.3),
                    height: 3.0,
                  ),
                ),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
