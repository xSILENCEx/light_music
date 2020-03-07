import 'package:flutter/material.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/helpers/font_icon.dart';
import 'package:light_player/util/app_util.dart';

///内容为空时显示的控件
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          FontIcons.feather4,
          size: 100,
          color: Theme.of(context).iconTheme.color.withOpacity(0.3),
        ),
        Divider(
          color: Colors.transparent,
        ),
        Text(
          AppL.of(context).translate('empty_info'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Lp.sp(36.0),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).iconTheme.color.withOpacity(0.3),
            height: 1.5,
          ),
        ),
        Text(
          'https://github.com/xSILENCEx/light_player',
          style: TextStyle(
            fontSize: Lp.sp(30.0),
            color: Theme.of(context).iconTheme.color.withOpacity(0.3),
            height: 3.0,
          ),
        ),
        Divider(
          height: Lp.w(100),
          color: Colors.transparent,
        ),
      ],
    );
  }
}
