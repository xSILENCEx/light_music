import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/auxiliary/bloc/music_bloc_helpers/play_helper.dart';
import 'package:light_player/auxiliary/helpers/follow_music_helper.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/objects/lp_music_player.dart';

import 'indicator_bloc.dart';

//刷新PlayBloc的必须枚举
enum PlayEve { reload }

///播放管理器
class PlayMag {
  ///音乐播放状态
  final LpMusicPlayer musicPlayer;

  const PlayMag({this.musicPlayer});

  PlayMag copyWith({final LpMusicPlayer musicPlayer}) => PlayMag(
        musicPlayer: musicPlayer ?? this.musicPlayer,
      );
}

///音乐播放bloc
class PlayBloc extends Bloc<PlayEve, PlayMag> {
  ///默认管理器
  LpMusicPlayer _musicPlayer = LpMusicPlayer();

  ///播放控制器
  AudioPlayer _audioPlayer;

  ///全局上下文BuildContext
  BuildContext _context;

  @override
  PlayMag get initialState => PlayMag(musicPlayer: _musicPlayer);

  ///初始化音乐管理器
  Future<void> init() async {
    try {
      ///初始化播放列表
      if (_musicPlayer.playList == null || _musicPlayer.playList.isEmpty) {
        _musicPlayer.playList = List<LpMusic>();
      }

      ///如果装载音乐为空,则生成默认音乐
      if (_musicPlayer.currentMusic == null) {
        _musicPlayer.currentMusic = LpMusic.def();
      }

      ///初始化音频控制器
      if (_audioPlayer == null) {
        _audioPlayer = AudioPlayer();
        _audioPlayer.setReleaseMode(ReleaseMode.STOP);
        _audioPlayer.state == AudioPlayerState.PLAYING ?? await this.stop();

        ///绑定监听播放完一首歌,播放下一曲
        _audioPlayer.onPlayerCompletion.listen((v) => this.next());

        ///绑定监听,音乐播放进度
        _audioPlayer.onAudioPositionChanged.listen((p) =>
            BlocProvider.of<IndicatorBloc>(_context).changeIndicator(
                p.inSeconds, this._musicPlayer.currentMusic.duration));

        print('音乐播放器初始化完成');
      }
    } catch (e) {
      print('PlayBloc初始化失败:$e');
    }
  }

  ///初始化全局上下文
  void initContext(BuildContext context) => this._context = context;

  ///跳转进度
  Future<void> seekTo(BuildContext context, int s) async {
    try {
      await _audioPlayer.seek(Duration(seconds: s));
      BlocProvider.of<IndicatorBloc>(_context)
          .changeIndicator(s, this._musicPlayer.currentMusic.duration);
      print('seek to $s');
    } catch (e) {
      print('进度跳转失败:$e');
    }
  }

  ///获取播放控制器
  AudioPlayer get getPlayController => this._audioPlayer;

  ///获取正在播放的音乐
  LpMusic get getCurrentMusic => this._musicPlayer.currentMusic;

  ///获取播放器播放状态
  AudioPlayerState get getAudioPlayerState => this._audioPlayer?.state;

  ///传入的音乐是否是正在播放的音乐
  bool isSameWithCurrent(LpMusic music) =>
      music.isSame(_musicPlayer.currentMusic);

  ///暂停音乐
  Future<void> pause() async {
    await _audioPlayer.pause();

    //延迟刷新，防止UI卡顿
    Future.delayed(Duration(milliseconds: 200), () => this.add(PlayEve.reload));
  }

  ///继续播放
  Future<void> resume() async {
    await _audioPlayer.resume();

    Future.delayed(Duration(milliseconds: 300), () {
      this.add(PlayEve.reload);
    });
  }

  ///确认从头播放一首歌曲,下一个方法 play() 的辅助方法
  Future<void> _realPlay(LpMusic music) async {
    try {
      //其它状态，从头开始播放该音乐
      //播放前先将目前的音乐停止
      await this.stop();

      //根据类型进行不同的播放
      switch (music.musicType) {

        ///播放本地音乐
        case MusicType.local:
          await _audioPlayer.play(music.sourceUrl,
              isLocal: true, stayAwake: true);

          break;

        ///播放在线音乐
        case MusicType.follow:
          await _audioPlayer
              .play(await QQMusicHelper.getQQPlayUrl(music.songMid));

          break;
        default:
      }

      _musicPlayer.currentMusic = music;

      _musicPlayer.musicIndex = await PlayHelper.asyncGetMusicIndex(
          _musicPlayer.playList, _musicPlayer.currentMusic);

      Future.delayed(
          Duration(milliseconds: 300), () => this.add(PlayEve.reload));
    } catch (e) {
      print('播放最终步骤出错:$e');
    }
  }

  ///播放指定音乐
  Future<void> play(LpMusic music,
      {List<LpMusic> list, bool isAuto = true}) async {
    try {
      ///手动选择时重载播放列表
      if (!isAuto) {
        assert(list != null, "If isAuto is false, list can't be null");
        reloadPlayList(list);
      }

      ///如果是同一首
      if (music.isSame(_musicPlayer.currentMusic)) {
        //首先判断此音乐的状态
        if (_audioPlayer.state == AudioPlayerState.PLAYING) {
          ///若为播放且为同一首，则暂停播放
          await this.pause();
        } else if (_audioPlayer.state == AudioPlayerState.PAUSED) {
          ///若为暂停，则恢复播放
          await this.resume();
        } else {
          ///从头播放
          await this._realPlay(music);
        }
      } else {
        ///从头播放
        await this._realPlay(music);
      }
    } catch (e) {
      print('播放出错:$e');
      _audioPlayer.release();
      BlocProvider.of<IndicatorBloc>(_context).changeIndicator(0, 0);
    }
  }

  ///停止音乐
  Future<void> stop() async {
    await _audioPlayer.stop();
    // _audioCache.clearCache();
  }

  ///上一曲
  Future<void> previous({bool isAuto = true}) async {
    try {
      switch (_musicPlayer.mode) {

        ///单曲循环
        case PlayMode.singleLoop:
          if (_musicPlayer.musicIndex > 0) {
            await this.play(_musicPlayer.playList[_musicPlayer.musicIndex - 1]);
          } else {
            await this
                .play(_musicPlayer.playList[_musicPlayer.playList.length - 1]);
          }
          break;

        ///列表循环
        case PlayMode.listLoop:
          if (_musicPlayer.musicIndex > 0) {
            await this.play(_musicPlayer.playList[_musicPlayer.musicIndex - 1]);
          } else {
            await this
                .play(_musicPlayer.playList[_musicPlayer.playList.length - 1]);
          }
          break;

        ///随机播放
        case PlayMode.shufflePlayback:
          // await this.resume();
          print('随机播放:上一曲');
          break;
        default:
          break;
      }
    } catch (e) {
      print('播放上一曲失败:$e');
    }
  }

  ///下一曲
  Future<void> next({bool isAuto = true}) async {
    try {
      LpMusic _nextMusic = LpMusic.def();

      switch (_musicPlayer.mode) {

        ///单曲循环
        case PlayMode.singleLoop:
          if (isAuto) {
            await this.resume();
          } else {
            if (_musicPlayer.musicIndex < _musicPlayer.playList.length - 1) {
              _nextMusic = _musicPlayer.playList[_musicPlayer.musicIndex + 1];
            } else {
              ///如果当前为最后一首
              _nextMusic = _musicPlayer.playList[0];
            }
          }

          break;

        ///列表循环
        case PlayMode.listLoop:
          if (_musicPlayer.musicIndex < _musicPlayer.playList.length - 1) {
            _nextMusic = _musicPlayer.playList[_musicPlayer.musicIndex + 1];
          } else {
            _nextMusic = _musicPlayer.playList[0];
          }
          break;

        ///随机播放
        case PlayMode.shufflePlayback:
          //生成一个不为当前索引的音乐位置
          _nextMusic = _musicPlayer.playList[_shuffleHelp()];
          break;
        default:
          break;
      }

      ///若歌曲无法播放则跳过
      if (!_nextMusic.pay) {
        _musicPlayer.currentMusic = _nextMusic;
        _musicPlayer.musicIndex = await PlayHelper.asyncGetMusicIndex(
            _musicPlayer.playList, _musicPlayer.currentMusic);
        await next();
        return;
      }

      await this.play(_nextMusic);
    } catch (e) {
      print('播放下一曲失败:$e');
    }
  }

  ///随机播放辅助
  int _shuffleHelp() {
    int _index = 0;
    while (true) {
      _index = math.Random().nextInt(_musicPlayer.playList.length - 1);
      if (_index != _musicPlayer.musicIndex) break;
    }
    return _index;
  }

  ///改变播放模式
  void changePlayMode(PlayMode playMode) {
    _musicPlayer.mode = playMode;

    print('change mode to:${_musicPlayer.mode}');

    Future.delayed(Duration(milliseconds: 500), () {
      this.add(PlayEve.reload);
    });
  }

  ///重载播放列表
  void reloadPlayList(List<LpMusic> newList, {bool isInit = false}) {
    _musicPlayer.playList.clear();
    _musicPlayer.playList.addAll(newList);

    if (isInit) _musicPlayer.currentMusic = newList[0];

    print('播放列表被刷新:${_musicPlayer.playList.length}');
  }

  ///释放播放器
  Future<void> desdroy() async {
    await _audioPlayer?.stop();
    await _audioPlayer?.release();
  }

  @override
  Stream<PlayMag> mapEventToState(PlayEve event) async* {
    yield state.copyWith(musicPlayer: _musicPlayer);
  }
}
