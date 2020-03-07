import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:light_player/bloc/playing_bloc.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_image.dart';
import 'package:music_player/music_player.dart';

class SpinCover extends StatefulWidget {
  const SpinCover({Key key}) : super(key: key);

  @override
  _SpinCoverState createState() => _SpinCoverState();
}

class _SpinCoverState extends State<SpinCover>
    with SingleTickerProviderStateMixin {
  AnimationController _animationCoverController;

  Animation _animationCover;

  double _coverSize = Lp.w(460);

  @override
  void initState() {
    super.initState();

    _animationCoverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    );

    _animationCover = Tween<double>(
      begin: 0.0,
      end: 360,
    ).animate(CurvedAnimation(
      parent: _animationCoverController,
      curve: Curves.linear,
    ));
  }

  Future _startPaperAnimation(bool isPlaying) async {
    try {
      if (isPlaying) {
        await _animationCoverController.repeat().orCancel;
      } else {
        _animationCoverController.stop();
      }
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    _animationCoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: _coverSize,
        height: _coverSize,
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.all(Lp.w(20.0)),
        child: ClipOval(
          child: BlocBuilder<PlayBloc, PlayMag>(builder: (c, play) {
            _startPaperAnimation(play.musicPlayer.state == PlayerState.Playing);
            return AnimatedBuilder(
              animation: _animationCoverController,
              child: LpImage(play.musicPlayer.data.iconUri),
              builder: (c, child) {
                return Transform.rotate(
                  angle: _animationCover.value,
                  child: child,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
