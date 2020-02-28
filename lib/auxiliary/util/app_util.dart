import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/loaders/color_loader_3.dart';
import 'package:light_player/auxiliary/others/app_local.dart';

///应用工具类
class Lp {
  ///初始化屏幕适配尺寸
  static initScreen(BuildContext context) {
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
  static void showTips(
    BuildContext context,
    String waringContent,
    String title, {
    Function onCheck,
    IconData checkIcon = Feather.check,
    bool isError = true,
  }) {
    Flushbar(
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
    )..show(context);
  }

  ///弹出内容
  static showContentDialog(BuildContext context, Widget content, String title) {
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

  ///创建缓存图
  static Widget pic(
    BuildContext context,
    String url, {
    double width = double.infinity,
    double height = double.infinity,
    Color color = Colors.transparent,
    double loadSize = 20,
    bool isShowLoad = true,
  }) {
    try {
      // print("picUrl:$url");
      if (url == null || url.length == 0) {
        url =
            "http://img04.taobaocdn.com/bao/uploaded/i4/TB2JOnSspXXXXbzXXXXXXXXXXXX_!!2080097744.jpg";
      }
      if (url.startsWith('/')) {
        ///本地图片
        return Image.file(
          File(url),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      } else if (url.startsWith('images/')) {
        return Image.asset(
          url,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      }

      ///网络图片
      return CachedNetworkImage(
        imageUrl: url,
        color: color,
        colorBlendMode: BlendMode.darken,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (c, s) => isShowLoad
            ? Center(
                child: loading2(
                  loadSize,
                  loadSize / 4,
                  Theme.of(context).accentColor,
                ),
              )
            : Center(),
        errorWidget: (c, s, o) => Image.asset(
          'images/btn_empty.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      print('load image error :$e');
    }

    return Center();
  }

  ///返回所有功能的名称
  static getFuncNames(BuildContext context) {
    return [
      AppL.of(context).translate('music'),
      AppL.of(context).translate('video'),
      AppL.of(context).translate('pictu'),
      AppL.of(context).translate('docum'),
    ];
  }

  ///添加角标
  static Widget bge(
      Widget content, BuildContext context, String count, bool show) {
    return Badge(
      animationDuration: Duration(milliseconds: 300),
      badgeColor: Theme.of(context).textTheme.display3.color,
      showBadge: show,
      padding: EdgeInsets.symmetric(
        vertical: w(2.0),
        horizontal: w(12.0),
      ),
      shape: BadgeShape.square,
      borderRadius: w(30.0),
      animationType: BadgeAnimationType.scale,
      elevation: 0.0,
      badgeContent: Container(
        alignment: Alignment.center,
        height: Lp.w(40.0),
        child: Text(
          count,
          style: TextStyle(
            fontSize: sp(30.0),
            color: Theme.of(context).bottomAppBarColor,
          ),
        ),
      ),
      child: content,
    );
  }

  ///加载圆圈
  static Widget loading(double size, double width, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: width,
      ),
    );
  }

  ///加载圆圈2
  static Widget loading2(double size, double dotSize, Color color) {
    return ColorLoader3(
      radius: size,
      dotRadius: dotSize,
    );
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
  static closeStuBar() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  ///显示状态栏与导航栏
  static openStuBar() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  ///通用返回按钮
  static leading(BuildContext context, {Color iconColor, double size}) {
    return IconButton(
      icon: Icon(
        Feather.chevron_left,
        size: size ?? Lp.w(60.0),
        color: iconColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
