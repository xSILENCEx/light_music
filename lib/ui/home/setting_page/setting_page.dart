import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/app_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/ui/home/setting_page/setting_item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'header_blur.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawKey =
        BlocProvider.of<AppBloc>(context).drawerKey;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (c, b) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).canvasColor,
              floating: true,
              pinned: true,
              elevation: 0.0,
              titleSpacing: 0.0,
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Feather.menu),
                onPressed: () => _drawKey.currentState.openDrawer(),
              ),
              expandedHeight: Lp.w(800),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                title: Text(
                  AppL.of(context).translate('setting').toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: BlocBuilder<StyleBloc, StyleMag>(
                  builder: (c, s) {
                    return Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      animationDuration: const Duration(seconds: 1),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(s.style.globalRadius)),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            'images/func4.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          HeaderBlur(controller: _scrollController),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: StaggeredGridView.countBuilder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Lp.w(40)),
          crossAxisCount: 4,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) =>
              SettingItem(index: index),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: Lp.w(40),
          crossAxisSpacing: Lp.w(40),
        ),
      ),
    );
  }
}
