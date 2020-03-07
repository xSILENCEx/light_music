import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/app_bloc.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/ui/root/root_page.dart';
import 'package:light_player/util/app_util.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _raedy(context);
  }

  void _raedy(BuildContext context) async {
    //初始化屏幕适配
    Lp.initScreen(context);

    ///初始化应用风格
    Offset _floatOffset =
        Offset(Lp.screenWidthDp - 100, Lp.screenHeightDp - 100);
    await BlocProvider.of<StyleBloc>(context)
        .init(context, offset: _floatOffset);

    //初始化应用配置
    await BlocProvider.of<AppBloc>(context).init();

    ///Android存储权限
    bool _storgePer = false;

    ///Android通知权限
    bool _notifyPer = false;

    //如果是安卓平台，进行上面的权限请求
    if (Platform.isAndroid) {
      ///Android端的存储权限请求
      _storgePer = await _checkPermission(PermissionGroup.storage, context);

      ///Android通知权限请求
      _notifyPer = await _checkPermission(PermissionGroup.reminders, context);
    } else {
      _storgePer = true;
      _notifyPer = true;
    }

    ///媒体库访问权限
    bool _mediaPer =
        await _checkPermission(PermissionGroup.mediaLibrary, context);

    if (_storgePer & _notifyPer & _mediaPer) {
      ///初始化播放管理器
      await BlocProvider.of<PlayBloc>(context).init();

      //成功后跳转
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const RootPage()),
          (route) => route == null);
    } else {
      SystemNavigator.pop();
    }
  }

  ///检查权限
  Future<bool> _checkPermission(
      PermissionGroup per, BuildContext context) async {
    bool _perAllow = false;

    ///当前状态
    final PermissionStatus _perState =
        await PermissionHandler().checkPermissionStatus(per);

    print("$per state : $_perState");

    switch (_perState) {

      ///同意授权
      case PermissionStatus.granted:
        _perAllow = true;
        break;

      ///IOS同意授权
      case PermissionStatus.restricted:
        _perAllow = true;
        break;

      ///未知授权状态
      case PermissionStatus.unknown:

        //请求该权限
        final Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler().requestPermissions([per]);

        if (permissions[per] == PermissionStatus.granted) {
          _perAllow = true;
        } else {
          ///弹出提示
          await Lp.showTips(
            context,
            AppL.of(context).translate('competence_res'),
            AppL.of(context).translate('warning').toUpperCase(),
          );
        }
        break;

      ///拒绝授权
      case PermissionStatus.denied:
        //请求该权限
        final Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler().requestPermissions([per]);

        if (permissions[per] == PermissionStatus.granted) {
          _perAllow = true;
        } else {
          ///弹出提示
          await Lp.showTips(
            context,
            AppL.of(context).translate('competence_res'),
            AppL.of(context).translate('warning').toUpperCase(),
          );
        }

        break;

      ///不再询问
      case PermissionStatus.neverAskAgain:
        print("object:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
        //请求该权限
        final Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler().requestPermissions([per]);

        if (permissions[per] == PermissionStatus.granted) {
          _perAllow = true;
        } else {
          ///弹出提示
          await Lp.showTips(
            context,
            AppL.of(context).translate('competence_res'),
            AppL.of(context).translate('warning').toUpperCase(),
          );
        }
        break;
    }

    print("$per:$_perAllow");

    return _perAllow;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        color: Theme.of(context).cardColor,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            //logo与标题
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/lp_text.png',
                  width: 265,
                  height: 47,
                ),
              ],
            ),

            //右下角加载动画
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(Lp.w(60.0)),
                  child: SizedBox(
                    width: Lp.w(40),
                    height: Lp.w(40),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      strokeWidth: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onWillPop: () => Future.value(null),
    );
  }
}
