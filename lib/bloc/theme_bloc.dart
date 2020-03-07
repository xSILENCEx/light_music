import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/objects/lp_config.dart';
import 'package:light_player/objects/lp_theme.dart';
import 'package:light_player/util/storage_util.dart';

///主题枚举
enum ThemeEve { reload }

///主题管理器
class ThemeMag {
  ///主题本体
  final LpTheme appTheme;

  ThemeMag({this.appTheme});

  ///重载方法
  ThemeMag copyWith({
    LpTheme appTheme,
  }) {
    return ThemeMag(
      appTheme: appTheme ?? this.appTheme,
    );
  }
}

///主题管理器
class ThemeBloc extends Bloc<ThemeEve, ThemeMag> {
  LpTheme _lpTheme = pureTheme;

  @override
  ThemeMag get initialState => ThemeMag(appTheme: _lpTheme);

  ///主题初始化
  init() async {
    //读取应用配置
    AppConfig _appInfo = AppConfig.fromJson(
      app: (await Storage.readFile('config', 'app', '初始化主题时')) ?? {},
    );

    switch (_appInfo.themeCode) {
      case 0:
        break;
      case 1:
        this.changeTheme(nightTheme);
        break;
      case 2:
        this.changeTheme(pinkTheme);
        break;
      case 3:
        this.changeTheme(coolTheme);
        break;
      default:
        break;
    }
  }

  ///切换主题
  Future<void> changeTheme(LpTheme theme) async {
    if (theme.code != this._lpTheme.code) {
      this._lpTheme = theme;
      add(ThemeEve.reload);
    }
  }

  Future<void> changeState() async {
    _lpTheme.themeFollowSystem = !_lpTheme.themeFollowSystem;

    await Future.delayed(
        const Duration(milliseconds: 300), () => this.add(ThemeEve.reload));
  }

  ///改变主题是否跟随系统

  @override
  Stream<ThemeMag> mapEventToState(ThemeEve event) async* {
    yield state.copyWith(appTheme: _lpTheme);
  }
}
