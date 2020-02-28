import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/loaders/color_loader_4.dart';
import 'package:photo_view/photo_view.dart';

class CoverPage extends StatelessWidget {
  const CoverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayMag>(
      builder: (c, play) {
        return GestureDetector(
          child: Material(
            elevation: 0.0,
            color: Colors.black,
            child: PhotoView(
              imageProvider:
                  NetworkImage(play.musicPlayer.currentMusic.coverUrl),
              loadingBuilder: (c, i) => Center(
                child: BlocBuilder<StyleBloc, StyleMag>(
                  builder: (c, s) {
                    return ColorLoader4(
                      dotOneColor: Theme.of(context).accentColor,
                      dotTwoColor: Theme.of(context).textTheme.display4.color,
                      dotThreeColor: Theme.of(context).textTheme.display3.color,
                      radius: s.style.globalRadius / 10 * 2,
                    );
                  },
                ),
              ),
              loadFailedChild: Image.asset(
                'images/btn_empty.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              onTapUp: (c, b, p) {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
