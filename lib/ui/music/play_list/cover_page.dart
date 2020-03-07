import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/widgets/lp_loader4.dart';
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
              imageProvider: NetworkImage(play.musicPlayer.data.iconUri),
              loadingBuilder: (c, i) => Center(
                child: const LpLoader4(),
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
