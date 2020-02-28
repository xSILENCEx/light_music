import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/bloc/theme_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_theme.dart';

import 'func_menu.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({Key key}) : super(key: key);

  ///切换主题颜色
  _changeTheme(BuildContext context, LpTheme theme) async {
    await Future.delayed(Duration(milliseconds: 300), () {});
    await BlocProvider.of<ThemeBloc>(context).changeTheme(theme);
  }

  ///改变应用圆角
  _changeRadius(BuildContext context, double radius) async {
    await Future.delayed(Duration(milliseconds: 300), () {});
    await BlocProvider.of<StyleBloc>(context).changeRadius(radius);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _accountBox(context),
              const FuncMenu(),
            ],
          ),
        ),
        _themes,
        _radius,
      ],
    );
  }

  ///登陆项
  Widget _accountBox(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        ///背景
        BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
          return Material(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(s.style.globalRadius * 10),
            ),
            animationDuration: const Duration(seconds: 1),
            child: SizedBox(width: double.infinity, height: Lp.w(500)),
          );
        }),

        ///头像与用户信息
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Lp.w(20)),
              child: SizedBox(
                width: Lp.w(240.0),
                height: Lp.w(240.0),
                child: FlatButton(
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Lp.w(300.0))),
                  padding: EdgeInsets.all(Lp.w(20.0)),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          'http://api.liugl.cn:8080/images/headpic/_OGGXf8t4y.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Lp.w(40)),
              child: Text(
                AppL.of(context).translate('unsign_info'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///构建主题按钮
  Widget get _themes {
    const List<IconData> _icons = [
      Feather.droplet,
      Feather.activity,
      Feather.box,
      Entypo.leaf,
      MaterialCommunityIcons.glasses,
    ];

    final List<LpTheme> _themes = [
      pureTheme,
      pinkTheme,
      coolTheme,
      natureTheme,
      nightTheme,
    ];

    return Padding(
      padding: EdgeInsets.all(Lp.w(40)),
      child: SizedBox(
        height: Lp.w(120),
        child: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
          return Material(
            clipBehavior: Clip.antiAlias,
            animationDuration: const Duration(seconds: 1),
            borderRadius: BorderRadius.circular(s.style.globalRadius * 0.6),
            child: ListView.separated(
              itemCount: _icons.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, index) {
                return MaterialButton(
                  elevation: 0.0,
                  focusElevation: 0.0,
                  highlightElevation: 0.0,
                  disabledElevation: 0.0,
                  hoverElevation: 0.0,
                  animationDuration: const Duration(seconds: 1),
                  clipBehavior: Clip.antiAlias,
                  color: _themes[index].startScreen,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(s.style.globalRadius * 0.6),
                  ),
                  padding: EdgeInsets.zero,
                  child: Icon(
                    _icons[index],
                    size: Lp.w(50),
                    color: Colors.white,
                  ),
                  onPressed: () => _changeTheme(c, _themes[index]),
                );
              },
              separatorBuilder: (c, index) {
                return SizedBox(width: 10);
              },
            ),
          );
        }),
      ),
    );
  }

  ///圆角调整
  Widget get _radius {
    return Padding(
      padding: EdgeInsets.fromLTRB(Lp.w(40), 0, Lp.w(40), Lp.w(40)),
      child: SizedBox(
        height: Lp.w(120),
        child: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
          return Material(
            animationDuration: const Duration(seconds: 1),
            borderRadius: BorderRadius.circular(s.style.globalRadius * 0.8),
            color: Theme.of(c).textTheme.display4.color,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Lp.w(25)),
              child: FlutterSlider(
                values: [s.style.globalRadius],
                max: 40,
                min: 0,
                handlerWidth: Lp.w(70),
                handlerHeight: Lp.w(70),
                handlerAnimation: FlutterSliderHandlerAnimation(
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.bounceIn,
                  duration: Duration(milliseconds: 300),
                  scale: 1.5,
                ),
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Material(
                    animationDuration: const Duration(seconds: 1),
                    borderRadius:
                        BorderRadius.circular(s.style.globalRadius * 0.4),
                    color: Theme.of(c).primaryColor,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(color: Colors.transparent),
                  activeTrackBar: BoxDecoration(color: Colors.transparent),
                ),
                tooltip: FlutterSliderTooltip(
                  textStyle: TextStyle(
                    fontSize: Lp.sp(40),
                    color: Theme.of(c).primaryColor,
                  ),
                  boxStyle: FlutterSliderTooltipBox(
                    decoration: BoxDecoration(
                      color: Theme.of(c).textTheme.display4.color,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(s.style.globalRadius),
                        bottom: Radius.circular(s.style.globalRadius * 3),
                      ),
                    ),
                  ),
                ),
                onDragCompleted: (handlerIndex, lowerValue, upperValue) =>
                    _changeRadius(c, lowerValue),
              ),
            ),
          );
        }),
      ),
    );
  }
}
