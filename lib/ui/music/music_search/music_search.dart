import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/search_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/loaders/color_loader_4.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/objects/lp_style.dart';
import 'package:light_player/ui/home/play_float_btn/play_float_btn.dart';

import '../music_item.dart';
import 'music_search_header.dart';

class MusicSearch extends StatefulWidget {
  const MusicSearch({Key key}) : super(key: key);

  @override
  _MusicSearchState createState() => _MusicSearchState();
}

class _MusicSearchState extends State<MusicSearch> {
  ///滚动控制器，用于监听
  ScrollController _scrollController;

  ///文本框控制器
  TextEditingController _editingController;

  ///搜索结果列表
  List<LpMusic> _resultList;

  @override
  void initState() {
    super.initState();
    _resultList = List<LpMusic>();
    _scrollController = ScrollController();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _resultList.clear();
    _resultList = null;
    _scrollController.dispose();
    _editingController.dispose();
    super.dispose();
  }

  ///删除一条历史
  _delete(String his) async {
    await BlocProvider.of<SearchBloc>(context).removeHisItem(his);
  }

  ///开始搜索
  _search(String keyWord, LpStyle style) async {
    if (keyWord != null && keyWord.length != 0) {
      _resultList.clear();
      _resultList = await BlocProvider.of<SearchBloc>(context).search(keyWord);
    } else
      Lp.showTopNotify(
        context,
        AppL.of(context).translate('tips').toUpperCase(),
        AppL.of(context).translate('empty_war'),
        radius: style.globalRadius,
      );
  }

  ///构建下半部主体
  Widget get _buildBody {
    return BlocBuilder<SearchBloc, SearchMag>(builder: (c, s) {
      ///历史记录
      List<Widget> _hisItems = List<Widget>();

      final List<String> _hisList = List.from(s.hisList.reversed);

      for (var i = 0; i < _hisList.length; i++) {
        _hisItems.add(_historyItem(_hisList[i]));
      }

      final List<Widget> _bodys = [
        ///结果列表
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: Lp.w(40), vertical: Lp.w(80)),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MusicItem(
                    index: index,
                    currentMusicList: _resultList,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              childCount: _resultList.length,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),

        ///搜索历史
        SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.fromLTRB(Lp.w(40), Lp.w(80), Lp.w(40), 0),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Entypo.feather,
                      size: Lp.w(80),
                      color: Theme.of(context).accentColor,
                    ),
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: Lp.sp(60),
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Lp.w(40)),
                Wrap(
                  spacing: Lp.w(40),
                  runSpacing: Lp.w(40),
                  children: _hisItems,
                ),
              ],
            ),
          ),
        ),

        ///没有数据
        SliverFillRemaining(
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
        ),

        ///出错
        SliverFillRemaining(
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
                    'error content : xxxxxxxxxxxxxxxxxxxxxxxxx',
                    style: TextStyle(fontSize: Lp.sp(40)),
                  ),
                ],
              ),
            ),
          ),
        ),

        ///正在加载
        SliverFillRemaining(
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
        ),
      ];

      return _bodys[s.searchState.index];
    });
  }

  ///历史记录item
  Widget _historyItem(String his) {
    return BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(s.style.globalRadius * 0.6),
        child: InkWell(
          child: Container(
            color: Theme.of(context).accentColor.withOpacity(0.5),
            padding: EdgeInsets.symmetric(horizontal: Lp.w(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ///文本区域
                LimitedBox(
                  maxWidth: Lp.w(500),
                  child: Text(
                    his,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Lp.sp(36),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                ///删除按钮
                SizedBox(
                  width: Lp.w(50),
                  height: Lp.w(80),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Feather.x,
                      size: Lp.w(36),
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => _delete(his),
                  ),
                ),
              ],
            ),
          ),
          onTap: () => _search(his, s.style),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          BlocBuilder<StyleBloc, StyleMag>(
              builder: (c, s) => MusicSearchHeader(
                    controller: _scrollController,
                    textEditingController: _editingController,
                    onSearch: (content) => _search(content, s.style),
                  )),
          _buildBody,
        ],
      ),
      floatingActionButton: PlayFloatActionBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
