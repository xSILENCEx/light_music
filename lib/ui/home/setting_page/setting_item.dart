import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/app_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/bloc/theme_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_style.dart';

class SettingItem extends StatelessWidget {
  final int index;

  const SettingItem({Key key, @required this.index}) : super(key: key);

  Future<void> _onSelect(BuildContext context) async {
    switch (index) {
      case 0:
        await BlocProvider.of<ThemeBloc>(context).changeState();
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        await BlocProvider.of<AppBloc>(context).changeFuncState(index);
        break;
      case 4:
        await BlocProvider.of<AppBloc>(context).changeFuncState(index);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _settingTitles = [
      AppL.of(context).translate("theme_system"),
      AppL.of(context).translate("show_lock"),
      AppL.of(context).translate("show_notif"),
      AppL.of(context).translate("push_switch"),
      AppL.of(context).translate("check_exit"),
      AppL.of(context).translate("clear_cache"),
    ];

    return BlocBuilder<StyleBloc, StyleMag>(
      builder: (c, s) {
        return Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          animationDuration: const Duration(seconds: 1),
          borderRadius: BorderRadius.circular(s.style.globalRadius),
          child: InkWell(
            splashColor: Colors.black,
            highlightColor: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(s.style.globalRadius),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).textTheme.display4.color.withOpacity(0.9),
                    Theme.of(context).accentColor.withOpacity(0.9),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildSwitch(context, s.style),
                  Padding(
                    padding: EdgeInsets.all(Lp.w(40)),
                    child: Text(
                      _settingTitles[index],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontSize: Lp.sp(60),
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _onSelect(context),
          ),
        );
      },
    );
  }

  ///构建开关
  Widget _buildSwitch(BuildContext context, LpStyle style) {
    switch (index) {
      case 0:
        return BlocBuilder<ThemeBloc, ThemeMag>(
            builder: (c, theme) =>
                _switch(context, style, theme.appTheme.themeFollowSystem));
        break;
      case 1:
        return BlocBuilder<AppBloc, AppMag>(
            builder: (c, app) =>
                _switch(context, style, app.appConfig.showLockScreen));
        break;
      case 2:
        return BlocBuilder<AppBloc, AppMag>(
            builder: (c, app) =>
                _switch(context, style, app.appConfig.showNotificationBar));
        break;
      case 3:
        return BlocBuilder<AppBloc, AppMag>(
            builder: (c, app) =>
                _switch(context, style, app.appConfig.pushSwitch));
        break;
      case 4:
        return BlocBuilder<AppBloc, AppMag>(
            builder: (c, app) =>
                _switch(context, style, app.appConfig.confirmBeforeExit));
        break;
      default:
        break;
    }
    return Container();
  }

  _switch(BuildContext context, LpStyle style, bool isOpen) {
    ///开关大小
    final double _switchSize = Lp.w(150);

    return Padding(
      padding: EdgeInsets.all(Lp.w(40)),
      child: Stack(
        children: <Widget>[
          Container(
            width: _switchSize,
            height: _switchSize * 0.5,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(style.globalRadius * 0.6),
            ),
          ),
          AnimatedPositioned(
            left: isOpen ? _switchSize * 0.45 : 0,
            curve: Curves.elasticOut,
            duration: const Duration(milliseconds: 800),
            child: Padding(
              padding: EdgeInsets.all(_switchSize * 0.05),
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
                width: _switchSize * 0.45,
                height: _switchSize * 0.4,
                decoration: BoxDecoration(
                  color: isOpen
                      ? Theme.of(context).accentColor
                      : Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(style.globalRadius * 0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
