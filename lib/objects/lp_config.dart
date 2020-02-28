import 'package:flutter/material.dart';

///当前选中的功能
enum NowFunc { music, video, picture, document, about }

///音乐的功能界面索引
enum MusicFunc { music, setting, feedback, about }

///应用配置
class AppConfig {
  ///主题编号
  int themeCode;

  ///是否是第一次运行
  bool isFirstRun;

  ///应用准备是否就绪
  bool isAllReady;

  ///当前功能
  MusicFunc nowFunc;

  ///侧边栏键值
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  ///在屏锁显示
  bool showLockScreen;

  ///在通知栏显示
  bool showNotificationBar;

  ///推送通知开关
  bool pushSwitch;

  ///退出前确认
  bool confirmBeforeExit;

  ///默认构造函数
  AppConfig({
    this.themeCode = 0,
    this.isFirstRun = true,
    this.isAllReady = false,
    this.nowFunc = MusicFunc.music,
    this.showLockScreen = false,
    this.showNotificationBar = false,
    this.pushSwitch = true,
    this.confirmBeforeExit = true,
  });

  ///从json创建AppConfig对象
  static AppConfig fromJson({Map app}) {
    return AppConfig(
      themeCode: app['themeCode'] ?? 0,
      isFirstRun: app['isFirstRun'] ?? true,
      isAllReady: app['isAllReady'] ?? false,
      nowFunc: app['nowFunc'] ?? MusicFunc.music,
    );
  }
}
