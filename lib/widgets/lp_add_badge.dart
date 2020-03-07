import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:light_player/util/app_util.dart';

///添加角标
class AddBadge extends StatelessWidget {
  const AddBadge({
    Key key,
    @required this.content,
    this.count = '',
    this.show = true,
  }) : super(key: key);

  final Widget content;
  final String count;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Badge(
      animationDuration: Duration(milliseconds: 300),
      badgeColor: Theme.of(context).textTheme.display3.color,
      showBadge: show,
      padding: EdgeInsets.symmetric(
        vertical: Lp.w(2.0),
        horizontal: Lp.w(12.0),
      ),
      shape: BadgeShape.square,
      borderRadius: Lp.w(30.0),
      animationType: BadgeAnimationType.scale,
      elevation: 0.0,
      badgeContent: Container(
        alignment: Alignment.center,
        height: Lp.w(40.0),
        child: Text(
          count,
          style: TextStyle(
            fontSize: Lp.sp(30.0),
            color: Theme.of(context).bottomAppBarColor,
          ),
        ),
      ),
      child: content,
    );
  }
}
