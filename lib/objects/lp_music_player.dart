import 'package:music_player/music_player.dart';

///播放状态
///  * [playing] 正在播放
///  * [pause] 暂停
///  * [stop] 停止

///播放器内容属性
class LpMusicPlayer {
  ///播放状态
  PlayerState state;

  MusicMetadata data;

  LpMusicPlayer({
    this.state = PlayerState.Paused,
    this.data,
  });
}
