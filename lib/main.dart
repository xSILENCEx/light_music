import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/objects/lp_theme.dart';
import 'package:light_player/ui/root/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:light_player/util/dio_util.dart';
import 'package:music_player/music_player.dart';

import 'bloc/app_bloc.dart';
import 'bloc/indicator_bloc.dart';
import 'bloc/playing_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/style_bloc.dart';
import 'bloc/theme_bloc.dart';
import 'helpers/app_local.dart';
import 'helpers/background.dart';

void main() {
  //状态栏透明
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  runApp(MyApp());
}

//后台播放与通知
@pragma("vm:entry-point")
void playerBackgroundService() {
  runBackgroundService(
    playUriInterceptor: (mediaId, fallbackUrl) async {
      return fallbackUrl;
    },
    imageLoadInterceptor: (metadata) async {
      try {
        ///解析网络图片流
        if (metadata.iconUri.startsWith("http")) {
          return await DioUtils.networkImageToByte(metadata.iconUri);
        } else {
          ///解析本地文件
          return await File(metadata.iconUri).readAsBytes();
        }
      } catch (e) {
        print('解析图片失败:$e');
      }

      return null;
    },
    playQueueInterceptor: LpPlayQueueInterceptor(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///主题刷新锁
    bool _refreshLock = true;

    return MultiBlocProvider(
      providers: <BlocProvider>[
        //主题管理器
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),

        //应用管理器
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
        ),

        //播放管理器
        BlocProvider<PlayBloc>(
          create: (context) => PlayBloc(),
        ),

        //应用风格管理器
        BlocProvider<StyleBloc>(
          create: (context) => StyleBloc(),
        ),

        //播放进度管理器
        BlocProvider<IndicatorBloc>(
          create: (context) => IndicatorBloc(),
        ),

        //搜索管理器
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMag>(
        builder: (BuildContext context, ThemeMag theme) {
          if (_refreshLock) {
            _appInit(context);
            _refreshLock = false;
          }

          return MaterialApp(
            title: 'Light Music',
            debugShowCheckedModeBanner: false,

            ///黑色主题
            darkTheme: theme.appTheme.themeFollowSystem
                ? ThemeData(
                    cardColor: nightTheme.startScreen,
                    accentColor: nightTheme.theme.shade500,
                    canvasColor: nightTheme.canvasColor,
                    primarySwatch: nightTheme.theme,
                    primaryColor: nightTheme.mainColor,
                    brightness: nightTheme.brightness,
                    iconTheme: IconThemeData(
                      color: nightTheme.iconColor,
                    ),
                    accentIconTheme: IconThemeData(
                      color: nightTheme.iconColor,
                    ),
                    primaryIconTheme: IconThemeData(
                      color: nightTheme.iconColor,
                    ),
                    textTheme: TextTheme(
                      display3: TextStyle(color: nightTheme.warningColor),
                      display4: TextStyle(color: nightTheme.dottedColor),
                    ),
                    bottomSheetTheme: BottomSheetThemeData(
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : null,

            ///常规主题
            theme: ThemeData(
              ///开屏颜色
              cardColor: theme.appTheme.startScreen,
              //主题色
              accentColor: theme.appTheme.theme.shade500,
              //默认背景色
              canvasColor: theme.appTheme.canvasColor,
              //强调颜色
              primarySwatch: theme.appTheme.theme,
              //整体色调
              primaryColor: theme.appTheme.mainColor,
              //颜色模式（亮色/暗色）
              brightness: theme.appTheme.brightness,
              buttonTheme: ButtonThemeData(),
              //图标默认色
              iconTheme: IconThemeData(
                color: theme.appTheme.iconColor,
              ),
              accentIconTheme: IconThemeData(
                color: theme.appTheme.iconColor,
              ),
              primaryIconTheme: IconThemeData(
                color: theme.appTheme.iconColor,
              ),

              textTheme: TextTheme(
                //警告色
                display3: TextStyle(
                  color: theme.appTheme.warningColor,
                ),
                //点缀色
                display4: TextStyle(
                  color: theme.appTheme.dottedColor,
                ),
              ),

              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.transparent,
              ),
            ),

            ///所有语言
            supportedLocales: [
              Locale('en', 'US'),
              Locale('zh', 'CH'),
            ],

            ///国际化设置
            localizationsDelegates: [
              AppL.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            ///重载语言切换方法
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supported) {
              for (var s in supported) {
                if (s.languageCode == locale.languageCode &&
                    s.countryCode == locale.countryCode) {
                  return s;
                }
              }

              return supported.first;
            },
            home: const SplashPage(),
          );
        },
      ),
    );
  }

  ///初始化相关管理器
  void _appInit(BuildContext context) async {
    await BlocProvider.of<ThemeBloc>(context).init();
    await BlocProvider.of<AppBloc>(context).init();
    await BlocProvider.of<SearchBloc>(context).init();
  }
}
