import 'package:light_player/objects/lp_music.dart';

///播放模式
///  * [listLoop] 列表循环
///  * [singleLoop] 单曲循环
///  * [shufflePlayback] 随机播放
enum PlayMode { listLoop, singleLoop, shufflePlayback }

///播放器内容属性
class LpMusicPlayer {
  ///播放列表
  List<LpMusic> playList;

  ///当前索引
  int musicIndex;

  ///正在播放的音乐
  LpMusic currentMusic;

  ///播放模式
  PlayMode mode;

  LpMusicPlayer({
    this.currentMusic,
    this.musicIndex = 0,
    this.mode = PlayMode.listLoop,
    this.playList = const <LpMusic>[],
  });
}
