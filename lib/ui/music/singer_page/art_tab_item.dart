import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_image.dart';

///有数据时的item
class ArtTabItem extends StatefulWidget {
  ///索引
  final int index;
  final ArtistInfo info;
  final Function onTap;

  const ArtTabItem({
    Key key,
    @required this.index,
    @required this.info,
    @required this.onTap,
  }) : super(key: key);

  @override
  _ArtTabItemState createState() => _ArtTabItemState();
}

class _ArtTabItemState extends State<ArtTabItem> {
  ///透明度
  double _op = 0.0;

  @override
  void initState() {
    super.initState();

    _opIn();
  }

  _opIn() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _op = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Lp.w(500),
      child: Padding(
        padding: EdgeInsets.all(Lp.w(20)),
        child: BlocBuilder<StyleBloc, StyleMag>(
          builder: (c, s) {
            return AnimatedOpacity(
              opacity: _op,
              duration: const Duration(milliseconds: 800),
              child: FlatButton(
                padding: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(s.style.globalRadius),
                ),
                child: Stack(
                  children: <Widget>[
                    LpImage(widget.info.artistArtPath),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black, Colors.transparent],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///标题
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Padding(
                                padding: EdgeInsets.all(Lp.w(40)),
                                child: Text(
                                  widget.info.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Lp.sp(50),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///信息
                          Padding(
                            padding: EdgeInsets.all(Lp.w(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  s.style.globalRadius * 0.6),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(Lp.w(30)),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppL.of(context)
                                                .translate('num_of_album') +
                                            ' : ${widget.info.numberOfAlbums}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Lp.sp(30),
                                          color: Theme.of(context)
                                              .textTheme
                                              .display4
                                              .color,
                                        ),
                                      ),
                                      Text(
                                        AppL.of(context)
                                                .translate('num_of_tracks') +
                                            ' : ${widget.info.numberOfAlbums}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Lp.sp(30),
                                          height: 1.5,
                                          color: Theme.of(context)
                                              .textTheme
                                              .display4
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onPressed: widget.onTap,
              ),
            );
          },
        ),
      ),
    );
  }
}
