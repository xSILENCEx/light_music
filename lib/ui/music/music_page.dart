import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/app_bloc.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';

import 'music_bar.dart';
import 'music_func.dart';
import 'music_list.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({Key key}) : super(key: key);

  ///本地与推荐视图
  List<Widget> get _views => <Widget>[
        extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('music0'),
          MusicList(musicType: MusicType.local),
        ),
        extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('music1'),
          MusicList(musicType: MusicType.follow),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawKey =
        BlocProvider.of<AppBloc>(context).drawerKey;

    return extended.NestedScrollView(
      pinnedHeaderSliverHeightBuilder: () =>
          MediaQuery.of(context).padding.top + kToolbarHeight,
      innerScrollPositionKeyBuilder: () {
        return Key('music${DefaultTabController.of(context).index}');
      },
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          <Widget>[
        ///头部内容
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: true,
          elevation: 0.0,
          titleSpacing: 0.0,
          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Feather.menu),
            onPressed: () => _drawKey.currentState.openDrawer(),
          ),
          title: Text(
            'LIGHT MUSIC',
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          expandedHeight: Lp.w(900),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
              bottom: kToolbarHeight + 10,
              left: Lp.w(40.0),
              right: Lp.w(40.0),
            ),
            child: const MusicFunc(),
          ),
          bottom: PreferredSize(
            child: const MusicTabbar(),
            preferredSize: const Size(double.infinity, kToolbarHeight),
          ),
        ),
      ],
      body: TabBarView(
        children: _views,
      ),
    );
  }
}
