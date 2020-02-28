import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/util/app_util.dart';

import 'album_cover.dart';
import 'btn_circle_indicator.dart';

///带动画的浮动按钮
class PlayFloatActionBtn extends StatefulWidget {
  const PlayFloatActionBtn({Key key}) : super(key: key);

  @override
  _PlayFloatActionBtnState createState() => _PlayFloatActionBtnState();
}

class _PlayFloatActionBtnState extends State<PlayFloatActionBtn> {
  ///按钮坐标
  Offset _floatOffset;

  ///按钮背景大小
  double _floatBgSize = 100;

  ///按钮大小
  double _floatBtnSize = 60;

  _onDragEnd(d) {
    _floatOffset = d.offset;

    if (Lp.screenHeightDp - _floatBgSize < d.offset.dy) {
      ///超出下边界
      _floatOffset = Offset(d.offset.dx, Lp.screenHeightDp - _floatBgSize);
    } else if (d.offset.dy < 0) {
      ///超出上边界
      _floatOffset = Offset(d.offset.dx, 0);
    }

    if (Lp.screenWidthDp - _floatBgSize < d.offset.dx) {
      ///超出右边界
      _floatOffset = Offset(Lp.screenWidthDp - _floatBgSize, _floatOffset.dy);
    } else if (d.offset.dx < 0) {
      ///超出左边界
      _floatOffset = Offset(0, _floatOffset.dy);
    }

    if ((Lp.screenWidthDp - _floatBgSize) / 2 > d.offset.dx) {
      BlocProvider.of<StyleBloc>(context).changePlayBtnPosition(_floatOffset);
    } else {
      BlocProvider.of<StyleBloc>(context).changePlayBtnPosition(_floatOffset);
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<StyleBloc, StyleMag>(
        builder: (c, s) => Stack(
          children: <Widget>[
            Positioned(
              width: _floatBgSize,
              height: _floatBgSize,
              top: s.style.playBtnOffset.dy,
              left: s.style.playBtnOffset.dx,
              child: LongPressDraggable(
                child: _buildNormalBtn,
                feedback: _buildDragBtn,
                childWhenDragging: Container(),
                onDragEnd: (d) => _onDragEnd(d),
              ),
            ),
          ],
        ),
      );

  ///按钮静止时的内容
  Widget get _buildNormalBtn => SizedBox(
        width: _floatBgSize,
        height: _floatBgSize,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ///背景与阴影
            SizedBox(
              width: _floatBtnSize,
              height: _floatBtnSize,
              child: Material(
                borderRadius: BorderRadius.circular(1000),
                elevation: 10.0,
                color: Theme.of(context).canvasColor,
              ),
            ),

            ///进度条
            BtnCircleIndicator(coverSize: _floatBtnSize),

            ///封面
            AlbumCover(coverSize: _floatBtnSize),
          ],
        ),
      );

  ///按钮拖动时的内容
  Widget get _buildDragBtn => SizedBox(
        width: _floatBgSize,
        height: _floatBgSize,
        child: Padding(
          padding: EdgeInsets.all((_floatBgSize - _floatBtnSize) / 2),
          child: Material(
            borderRadius: BorderRadius.circular(1000),
            color: Theme.of(context).canvasColor,
            elevation: 10.0,
            child: Icon(Feather.move, size: Lp.w(40)),
          ),
        ),
      );
}
