import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/app_bloc.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/objects/lp_config.dart';
import 'package:light_player/ui/home/about/about_page.dart';
import 'package:light_player/ui/home/feedback/feed_page.dart';
import 'package:light_player/ui/home/left_drawer/app_drawer.dart';
import 'package:light_player/ui/home/play_float_btn/play_float_btn.dart';
import 'package:light_player/ui/home/setting_page/setting_page.dart';
import 'package:light_player/ui/music/music_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key key}) : super(key: key);

  ///不杀死程序返回桌面
  Future<void> _backDeskTop() async {
    //初始化通信管道-设置退出到手机桌面
    String _channel = "back/desktop";
    final MethodChannel _platform = MethodChannel(_channel);
    //通知安卓返回,到手机桌面
    try {
      final bool out = await _platform.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
      print(e.toString());
    }
    return Future.value(false);
  }

  ///退出前确认
  Future<void> _exit(BuildContext context, PageController controller) async {
    if (BlocProvider.of<AppBloc>(context).drawerKey.currentState.isDrawerOpen) {
      Navigator.pop(context);
    } else if (controller.page != 0) {
      BlocProvider.of<AppBloc>(context).changeFunc(MusicFunc.music);
    } else {
      await _backDeskTop();
    }

    return await Future.value(false);
  }

  ///跳转到指定功能页面
  Future<void> _jumpToPage(int index, PageController pageController) async {
    if (pageController.hasClients) pageController?.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    ///所有功能页面
    const List<Widget> _pages = [
      const DefaultTabController(length: 2, child: const MusicPage()),
      const SettingPage(),
      const FeedbackPage(),
      const AboutPage(),
    ];

    final GlobalKey<ScaffoldState> _drawKey =
        BlocProvider.of<AppBloc>(context).drawerKey;
    final PageController _pageController = PageController();

    BlocProvider.of<PlayBloc>(context).initContext(context);

    return WillPopScope(
      child: Scaffold(
        key: _drawKey,
        backgroundColor: Theme.of(context).primaryColor,
        drawer: const AppDrawer(),
        body: BlocBuilder<AppBloc, AppMag>(
          builder: (c, app) {
            _jumpToPage(app.appConfig.nowFunc.index, _pageController);

            ///堆叠页面
            return PageView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _pages,
            );
          },
        ),
        floatingActionButton: const PlayFloatActionBtn(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      onWillPop: () => _exit(context, _pageController),
    );
  }
}
