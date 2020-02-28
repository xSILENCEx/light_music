import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/app_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/ui/root/root_page.dart';
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
    bool _storgePer = true;

    ///Android通知权限
    bool _notifyPer = true;

    //如果是安卓平台，进行上面的权限请求
    if (Platform.isAndroid) {
      ///Android端的存储权限请求
      _storgePer = await _checkPermission(PermissionGroup.storage, context);

      ///Android通知权限请求
      _notifyPer = await _checkPermission(PermissionGroup.reminders, context);
    }

    ///媒体库访问权限
    bool _mediaPer =
        await _checkPermission(PermissionGroup.mediaLibrary, context);

    if (_storgePer & _notifyPer & _mediaPer) {
      //成功后跳转
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => RootPage()),
          (route) => route == null);
    }
  }

  _checkPermission(PermissionGroup per, BuildContext context) async {
    bool _per = false;
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(per);
    switch (permission) {
      case PermissionStatus.unknown:
        {
          Map<PermissionGroup, PermissionStatus> permissions =
              await PermissionHandler().requestPermissions([per]);
          if (permissions['Permission'] == PermissionStatus.disabled) {
          } else {
            _per = true;
          }
        }
        break;
      case PermissionStatus.granted:
        {
          _per = true;
        }
        break;
      case PermissionStatus.restricted:
        {
          Lp.showTips(
            context,
            AppL.of(context).translate('competence_res'),
            AppL.of(context).translate('warning').toUpperCase(),
          );
        }
        break;
      case PermissionStatus.denied:
        {
          Map<PermissionGroup, PermissionStatus> permissions =
              await PermissionHandler().requestPermissions([per]);
          if (permissions['Permission'] == PermissionStatus.disabled) {
            // storagePermission = false;
          } else {
            _per = true;
          }
        }
        break;
      case PermissionStatus.disabled:
        {
          Lp.showTips(
            context,
            AppL.of(context).translate('competence_dis'),
            AppL.of(context).translate('warning').toUpperCase(),
          );
        }
        break;
    }

    print("$per:$_per");
    return _per;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                child: Lp.loading(Lp.w(40), 1, Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
