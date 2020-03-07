import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/app_bloc.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/objects/lp_config.dart';
import 'package:light_player/util/app_util.dart';

///侧边栏选项
class SelectItem extends StatelessWidget {
  const SelectItem({
    Key key,
    @required this.index,
    @required this.icon,
    this.title = 'Title',
  }) : super(key: key);

  ///索引
  final int index;

  ///图标
  final IconData icon;

  ///选项标题
  final String title;

  ///退出确认
  Future<void> _exit(BuildContext context) async {
    if (BlocProvider.of<AppBloc>(context).exitCheck) {
      Lp.showTips(
        context,
        AppL.of(context).translate('quit_tips'),
        AppL.of(context).translate('tips').toUpperCase(),
        onCheck: () async {
          await BlocProvider.of<PlayBloc>(context).destroy();
          SystemNavigator.pop();
        },
      );
    } else {
      await BlocProvider.of<PlayBloc>(context).destroy();
      SystemNavigator.pop();
    }

    return await Future.value(false);
  }

  ///点击选项改变currentPage
  _tapItem(AppBloc bloc, BuildContext context) async => index == 4
      ? await _exit(context)
      : await bloc.changeFunc(MusicFunc.values[index]);

  @override
  Widget build(BuildContext context) {
    final _appBloc = BlocProvider.of<AppBloc>(context);

    return BlocBuilder<AppBloc, AppMag>(
      builder: (BuildContext context, AppMag app) {
        return Stack(
          children: <Widget>[
            //按钮背景
            BlocBuilder<StyleBloc, StyleMag>(
              builder: (c, s) {
                return Material(
                  animationDuration: const Duration(seconds: 1),
                  borderRadius:
                      BorderRadius.circular(s.style.globalRadius * 0.8),
                  color: Theme.of(context).accentColor,
                  child: AnimatedContainer(
                    height: Lp.w(150.0),
                    width:
                        app.appConfig.nowFunc.index == index ? Lp.w(500.0) : 0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease,
                  ),
                );
              },
            ),

            //按钮内容
            BlocBuilder<StyleBloc, StyleMag>(
              builder: (c, s) {
                return FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(s.style.globalRadius * 0.8),
                  ),
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: Lp.w(150.0),
                    width: Lp.w(500.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: Lp.w(50.0)),
                        AnimatedTheme(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                          data: ThemeData(
                            iconTheme: IconThemeData(
                              size: app.appConfig.nowFunc.index == index
                                  ? Lp.w(76.0)
                                  : Lp.w(54.0),
                              color: index == 4
                                  ? Theme.of(context).textTheme.display3.color
                                  : app.appConfig.nowFunc.index == index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .iconTheme
                                          .color
                                          .withOpacity(0.6),
                            ),
                          ),
                          child: Container(
                            width: Lp.w(80),
                            height: Lp.w(80),
                            alignment: Alignment.center,
                            child: Icon(icon),
                          ),
                        ),
                        SizedBox(width: Lp.w(50.0)),
                        AnimatedDefaultTextStyle(
                          child: Text(title),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                          style: TextStyle(
                            color: index == 4
                                ? Theme.of(context).textTheme.display3.color
                                : app.appConfig.nowFunc.index == index
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .iconTheme
                                        .color
                                        .withOpacity(0.6),
                            fontWeight: app.appConfig.nowFunc.index == index
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () => _tapItem(_appBloc, context),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
