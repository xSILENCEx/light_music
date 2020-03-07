import 'package:flutter/material.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/helpers/font_icon.dart';
import 'package:light_player/util/app_util.dart';

class LpErrorWidget extends StatelessWidget {
  const LpErrorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
          AppL.of(context).translate('unknown_error'),
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
          textAlign: TextAlign.center,
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
