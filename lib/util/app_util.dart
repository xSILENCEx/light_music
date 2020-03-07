import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:light_player/bloc/style_bloc.dart';

///应用工具类
class Lp {
  ///初始化屏幕适配尺寸
  static void initScreen(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2160, allowFontScaling: true);
  }

  ///弹出应用内顶部通知
  static void showTopNotify(BuildContext context, String title, String content,
      {double radius = 14, VoidCallback onTap}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Theme.of(context).accentColor,
      margin: EdgeInsets.all(Lp.w(40.0)),
      padding: EdgeInsets.all(Lp.w(50.0)),
      borderRadius: radius,
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      messageText: Text(
        content,
        style: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
      ),
      onTap: (c) => onTap ?? null,
      onStatusChanged: (s) => null,
    )..show(context);
  }

  ///弹出底部提示框 * 仅限文本
  static Future<void> showTips(
      BuildContext context, String waringContent, String title,
      {Function onCheck,
      IconData checkIcon = Feather.check,
      bool isError = true}) async {
    final bar = Flushbar(
      forwardAnimationCurve: Curves.elasticOut,
      reverseAnimationCurve: Curves.easeOutQuint,
      animationDuration: Duration(milliseconds: 800),
      backgroundColor: Colors.transparent,
      overlayColor: Colors.black26,
      overlayBlur: 0.1,
      margin: EdgeInsets.all(Lp.w(40.0)),
      padding: EdgeInsets.zero,
      messageText: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
        return Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(s.style.globalRadius),
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Lp.w(80), vertical: Lp.w(40)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///选项
                Row(
                  children: <Widget>[
                    ///关闭菜单
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(s.style.globalRadius * 0.6),
                        ),
                        padding: EdgeInsets.symmetric(vertical: Lp.w(40.0)),
                        onPressed: () => Navigator.pop(context),
                        child: Icon(
                          Feather.x,
                          size: Lp.w(60.0),
                          color: Theme.of(context).textTheme.display3.color,
                        ),
                      ),
                    ),

                    ///确认
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(s.style.globalRadius * 0.6),
                        ),
                        padding: EdgeInsets.symmetric(vertical: Lp.w(40.0)),
                        onPressed: onCheck ?? () => Navigator.pop(context),
                        child: Icon(
                          checkIcon,
                          size: Lp.w(60.0),
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                //标题
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Lp.w(40)),
                  child: Text(
                    title + ' :',
                    style: TextStyle(
                      fontSize: Lp.sp(50.0),
                      color: isError
                          ? Theme.of(context).textTheme.display3.color
                          : Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //内容
                LimitedBox(
                  maxHeight: Lp.w(500),
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: Lp.w(80)),
                    children: <Widget>[
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          waringContent,
                          style: TextStyle(
                            fontSize: Lp.sp(40.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      onTap: null,
      onStatusChanged: (s) => null,
    );

    await bar.show(context);
  }

  ///弹出内容
  static void showContentDialog(
      BuildContext context, Widget content, String title) {
    Flushbar(
      animationDuration: const Duration(milliseconds: 500),
      backgroundColor: Colors.transparent,
      overlayColor: Colors.black26,
      overlayBlur: 0.1,
      margin: EdgeInsets.all(Lp.w(40.0)),
      padding: EdgeInsets.zero,
      messageText: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
        return Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(s.style.globalRadius),
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Lp.w(80), vertical: Lp.w(80)),
            child: Column(
              children: <Widget>[
                content,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Lp.w(100)),
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: Lp.sp(40.0),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      onTap: null,
      onStatusChanged: (s) => null,
    )..show(context);
  }

  ///适配元素大小
  static double w(double width) {
    return ScreenUtil().setWidth(width);
  }

  ///适配字体大小
  static double sp(double sp) {
    return ScreenUtil().setSp(sp);
  }

  ///返回屏幕逻辑宽度
  static double get screenWidthDp {
    return ScreenUtil.screenWidthDp;
  }

  ///返回屏幕逻辑高度
  static double get screenHeightDp {
    return ScreenUtil.screenHeightDp;
  }

  ///返回屏幕逻辑宽度
  static double get screenWidth {
    return ScreenUtil.screenWidth;
  }

  ///返回屏幕逻辑高度
  static double get screenHeight {
    return ScreenUtil.screenHeight;
  }

  ///隐藏状态栏与导航栏
  static void closeStuBar() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  ///显示状态栏与导航栏
  static void openStuBar() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
}
