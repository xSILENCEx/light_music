import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/ui/home/play_float_btn/play_float_btn.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_image.dart';

import 'album_head_title.dart';
import 'album_song_list.dart';

///指定id的专辑
class SingleAlbum extends StatelessWidget {
  ///序列
  final int index;

  ///专辑信息
  final AlbumInfo info;

  const SingleAlbum({Key key, @required this.index, @required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).canvasColor,
            expandedHeight: Lp.screenHeightDp / 2,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.zero,
              title: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
                return SizedBox(
                  width: Lp.screenWidthDp / 1.5,
                  height: kToolbarHeight,
                  child: FlatButton(
                    splashColor: Theme.of(context).accentColor,
                    clipBehavior: Clip.antiAlias,
                    padding: EdgeInsets.symmetric(horizontal: Lp.w(40)),
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(s.style.globalRadius / 1.5),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Feather.chevron_left, size: Lp.w(46)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              info.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Icon(Feather.chevron_right, size: Lp.w(46)),
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                );
              }),
              background: Stack(
                children: <Widget>[
                  BlocBuilder<StyleBloc, StyleMag>(
                    builder: (c, s) {
                      return Hero(
                        tag: 'cover$index',
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(s.style.globalRadius),
                          ),
                          child: LpImage(info.albumArt),
                        ),
                      );
                    },
                  ),
                  AlbumHeadTitle(info: info, index: index),
                ],
              ),
            ),
          ),
          SongList(albumInfo: info),
        ],
      ),
      floatingActionButton: PlayFloatActionBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
