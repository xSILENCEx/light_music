import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/util/app_util.dart';

import 'album_body.dart';
import 'album_title.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: 'album',
          child: Image.asset(
            'images/func2.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              AlbumTitle(),

              ///返回按钮
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Lp.w(80),
                  vertical: Lp.w(80),
                ),
                child: Hero(
                  tag: 'album_box',
                  child: BlocBuilder<StyleBloc, StyleMag>(
                    builder: (c, s) => FlatButton(
                      splashColor: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(s.style.globalRadius),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Lp.w(40),
                        vertical: Lp.w(80),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Feather.chevron_left, color: Colors.white),
                          Text(
                            AppL.of(context).translate('click_to_return'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Lp.sp(50),
                            ),
                          ),
                          Icon(Feather.chevron_right, color: Colors.white),
                        ],
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AlbumBody(),
      ],
    );
  }
}
