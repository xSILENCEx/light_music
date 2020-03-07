import 'package:flutter/material.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/util/app_util.dart';

//标题
class AlbumTitle extends StatefulWidget {
  const AlbumTitle({Key key}) : super(key: key);

  @override
  _AlbumTitleState createState() => _AlbumTitleState();
}

class _AlbumTitleState extends State<AlbumTitle> {
  ///控件透明度
  double _op = 0.0;

  @override
  void initState() {
    super.initState();

    _opIn();
  }

  _opIn() async {
    await Future.delayed(
        const Duration(milliseconds: 800),
        () => setState(() {
              _op = 1.0;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _op,
      duration: const Duration(milliseconds: 800),
      child: Text(
        AppL.of(context).translate('album'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: Lp.sp(120),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
