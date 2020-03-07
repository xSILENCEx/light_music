import 'package:flutter/material.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/util/app_util.dart';

class MusicTabbar extends StatelessWidget {
  const MusicTabbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabTitles = [
      AppL.of(context).translate('local'),
      AppL.of(context).translate('follow'),
    ];

    final List<Widget> _t = List<Widget>();

    _tabTitles.forEach((t) {
      _t.add(Tab(
        text: t,
      ));
    });

    return Container(
      width: double.infinity,
      height: kToolbarHeight,
      color: Theme.of(context).primaryColor,
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          isScrollable: true,
          tabs: _t,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).accentColor.withOpacity(0.3),
          labelStyle: TextStyle(
            fontSize: Lp.sp(60.0),
            fontWeight: FontWeight.w500,
          ),
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.zero,
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
