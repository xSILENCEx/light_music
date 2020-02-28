import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/objects/lp_config.dart';

//刷新AppBloc的必须枚举
enum AppEve { reload }

///应用配置状态
class AppMag {
  final AppConfig appConfig;

  const AppMag({this.appConfig});

  AppMag copyWith({AppConfig appConfig}) {
    return AppMag(
      appConfig: appConfig ?? this.appConfig,
    );
  }
}

class AppBloc extends Bloc<AppEve, AppMag> {
  AppConfig _appConfig = AppConfig();

  @override
  AppMag get initialState => AppMag(appConfig: _appConfig);

  init() async {
    // await Future.delayed(Duration(seconds: 2), () {});
  }

  ///获取主体全局键值
  GlobalKey<ScaffoldState> get drawerKey => _appConfig.drawerKey;

  bool get exitCheck => _appConfig.confirmBeforeExit;

  ///获取当前功能的索引
  int get funcIndex => _appConfig.nowFunc.index;

  ///切换应用设置项状态
  Future<void> changeFuncState(int funcIndex) async {
    switch (funcIndex) {

      ///在锁屏上显示
      case 1:
        break;

      ///在通知栏显示
      case 2:
        break;

      ///推送开关
      case 3:
        _appConfig.pushSwitch = !_appConfig.pushSwitch;
        break;

      ///退出前确认
      case 4:
        _appConfig.confirmBeforeExit = !_appConfig.confirmBeforeExit;
        break;
      default:
    }

    await Future.delayed(
        const Duration(milliseconds: 500), () => this.add(AppEve.reload));
  }

  ///切换当前功能页面
  changeFunc(MusicFunc f) async {
    if (_appConfig.nowFunc != f) {
      _appConfig.nowFunc = f;
      add(AppEve.reload);
    }
  }

  @override
  Stream<AppMag> mapEventToState(AppEve event) async* {
    yield state.copyWith(appConfig: _appConfig);
  }
}
