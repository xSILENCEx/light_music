import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:light_player/plugins/loaders/color_loader_3.dart';

///创建图片模板
class LpImage extends StatelessWidget {
  const LpImage(
    this.url, {
    Key key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.color = Colors.transparent,
    this.loadSize = 20,
    this.isShowLoad = true,
  }) : super(key: key);

  ///图片路径
  final String url;
  final double width;
  final double height;
  final Color color;
  final double loadSize;
  final bool isShowLoad;

  @override
  Widget build(BuildContext context) {
    String _imageUrl;

    try {
      if (url == null || url.length == 0) {
        _imageUrl =
            "http://img04.taobaocdn.com/bao/uploaded/i4/TB2JOnSspXXXXbzXXXXXXXXXXXX_!!2080097744.jpg";
      } else {
        _imageUrl = url;
      }
      if (_imageUrl.startsWith('/')) {
        ///本地图片
        return Image.file(
          File(_imageUrl),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      } else if (_imageUrl.startsWith('images/')) {
        return Image.asset(
          _imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      }

      ///网络图片
      return CachedNetworkImage(
        imageUrl: _imageUrl,
        color: color,
        colorBlendMode: BlendMode.darken,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (c, s) => isShowLoad
            ? Center(
                child: ColorLoader3(radius: loadSize, dotRadius: loadSize / 4))
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
}
