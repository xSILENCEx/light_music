import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/search_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/objects/lp_style.dart';
import 'package:light_player/ui/music/singer_page/singer_page.dart';
import 'package:light_player/util/app_util.dart';

import 'album_page/album_page.dart';
import 'music_search/music_search.dart';

class MusicFunc extends StatelessWidget {
  const MusicFunc({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) {
        return Material(
          animationDuration: const Duration(seconds: 1),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(s.style.globalRadius * 0.8),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, index) => _buildToolItem(c, index, s.style),
            separatorBuilder: (c, index) => const SizedBox(width: 20),
            itemCount: 4,
          ),
        );
      },
    );
  }

  ///构建工具项
  Widget _buildToolItem(BuildContext context, int index, LpStyle style) {
    ///功能名称
    final _toolNames = [
      AppL.of(context).translate('play_list'),
      AppL.of(context).translate('search'),
      AppL.of(context).translate('album'),
      AppL.of(context).translate('singer'),
    ];

    ///hero图片动画tag
    const List<String> _tags = ['playlist', 'search', 'album', 'singer'];

    ///hero按钮动画tag
    const List<String> _btnTags = [
      'playlist_box',
      'search_box',
      'album_box',
      'singer_box'
    ];

    ///hero标题动画tag
    const List<String> _titleTags = [
      'playlist_t',
      'search_t',
      'album_t',
      'singer_t'
    ];

    ///功能页面
    List<Widget> _toolPages = [
      //TODO 构建播放列表页面
      const Scaffold(),
      const MusicSearch(),
      const AlbumPage(),
      const SingerPage(),
    ];

    return Material(
      clipBehavior: Clip.antiAlias,
      animationDuration: const Duration(seconds: 1),
      borderRadius: BorderRadius.circular(style.globalRadius * 0.8),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Hero(
            tag: _tags[index],
            child: Material(
              clipBehavior: Clip.antiAlias,
              animationDuration: const Duration(seconds: 1),
              borderRadius: BorderRadius.circular(style.globalRadius * 0.8),
              child: Image.asset('images/func${index + 1}.png'),
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: Hero(
              tag: _btnTags[index],
              child: MaterialButton(
                elevation: 0.0,
                focusElevation: 0.0,
                highlightElevation: 0.0,
                disabledElevation: 0.0,
                hoverElevation: 0.0,
                animationDuration: const Duration(seconds: 1),
                splashColor: Theme.of(context).accentColor,
                color: Colors.black.withOpacity(0.4),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(style.globalRadius * 0.8),
                ),
                padding: EdgeInsets.zero,
                child: null,
                onPressed: () async {
                  await Navigator.of(context)
                      .push(
                    MaterialPageRoute(builder: (c) => _toolPages[index]),
                  )
                      .then((v) {
                    BlocProvider.of<SearchBloc>(context)
                        .changeState(SearchState.history);
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 88,
            child: Hero(
              tag: _titleTags[index],
              child: Material(
                color: Colors.transparent,
                child: Text(
                  _toolNames[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Lp.sp(40),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
