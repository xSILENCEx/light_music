import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/objects/lp_music_player.dart';
import 'package:music_player/music_player.dart';

import 'app_bloc.dart';
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
  LpMusicPlayer _musicPlayer = LpMusicPlayer()
    ..data = MusicMetadata(
      mediaId: 'id',
      title: "",
      subtitle: "",
      duration: 1,
      iconUri:
          "http://img04.taobaocdn.com/bao/uploaded/i4/TB2JOnSspXXXXbzXXXXXXXXXXXX_!!2080097744.jpg",
      mediaUri: "",
    );

  ///播放器
  MusicPlayer _player = MusicPlayer();

  ///刷新锁
  bool _updateLock = true;

  ///全局上下文
  BuildContext _context;

  ///进度刷新计时器
  Timer _timer;

  @override
  PlayMag get initialState => PlayMag(musicPlayer: _musicPlayer);

  ///初始化音乐管理器
  Future<void> init() async {
    try {
      ///添加音频控制监听
      _player.removeListener(_update);
      _player.addListener(_update);
      print('音乐播放器初始化完成');
    } catch (e) {
      print('PlayBloc初始化失败:$e');
    }
  }

  ///获取播放控制器
  MusicPlayer get getPlayer => _player;

  ///初始化全局上下文
  void initContext(BuildContext context) => _context = context;

  ///初始化默认音乐
  Future<void> initFirstSong(LpMusic music, PlayQueue playQueue) async {
    try {
      await play(music: music, playQueue: playQueue);

      _musicPlayer.data = music;

      BlocProvider.of<IndicatorBloc>(_context)
          .changeIndicator(0, music.duration);

      Future.delayed(const Duration(milliseconds: 400), () {
        seekTo(0);
        pause();
        print('state:${_player.playbackState.state.toString()}');
      });

      Future.delayed(const Duration(seconds: 1), () {
        BlocProvider.of<AppBloc>(_context).changeFuncState(5);
      });

      print('初始化默认音乐完成');
    } catch (e) {
      print('初始化默认音乐出错:$e');
    }
  }

  ///获取正在播放的音乐在当前播放列表中的位置
  int get getIndex => _player.queue.queue
      .indexWhere((m) => m.mediaId == _musicPlayer.data.mediaId);

  ///获取播放模式
  PlayMode get playMode => _player.value.playMode;

  ///跳转进度
  Future<void> seekTo(int s) async {
    try {
      await _player.transportControls.seekTo(s);
      BlocProvider.of<IndicatorBloc>(_context)
          .changeIndicator(s, _musicPlayer.data?.duration ?? 10000);
      print('seek to $s');
    } catch (e) {
      print('进度跳转失败:$e');
    }
  }

  ///暂停音乐
  Future<void> pause() async {
    await _player.transportControls.pause();

    _musicPlayer.state = PlayerState.Paused;

    //延迟刷新，防止UI卡顿
    Future.delayed(
        const Duration(milliseconds: 200), () => this.add(PlayEve.reload));
  }

  ///继续播放
  Future<void> resume() async {
    await _player.transportControls.play();

    _musicPlayer.state = PlayerState.Playing;

    //延迟刷新，防止UI卡顿
    Future.delayed(
        const Duration(milliseconds: 200), () => this.add(PlayEve.reload));
  }

  ///播放指定音乐
  Future<void> play(
      {MusicMetadata music, PlayQueue playQueue, bool isAuto = true}) async {
    try {
      ///手动选择时重载播放列表
      if (!isAuto) {
        assert(playQueue != null, "If isAuto is false, list can't be null");
      }

      ///如果是同一首
      if (music == null || _player.metadata?.mediaId == music.mediaId) {
        //首先判断此音乐的状态
        if (_player.playbackState.state == PlayerState.Playing) {
          ///若为播放且为同一首，则暂停播放
          await this.pause();
        } else if (_player.playbackState.state == PlayerState.Paused) {
          ///若为暂停，则恢复播放
          await this.resume();
        } else {
          ///从头播放
          _player.playWithQueue(playQueue, metadata: music);
          _musicPlayer.state = PlayerState.Playing;
        }
      } else {
        ///从头播放
        _player.playWithQueue(playQueue, metadata: music);
        _musicPlayer.state = PlayerState.Playing;
      }
    } catch (e) {
      print('播放出错:$e');
    }
  }

  ///上一曲
  Future<void> previous({bool isAuto = true}) async {
    try {
      await _player.transportControls.skipToPrevious();
      _musicPlayer.state = PlayerState.Playing;
    } catch (e) {
      print('播放上一曲失败:$e');
    }
  }

  ///下一曲
  Future<void> next({bool isAuto = true}) async {
    try {
      await _player.transportControls.skipToNext();
      _musicPlayer.state = PlayerState.Playing;
    } catch (e) {
      print('播放下一曲失败:$e');
    }
  }

  ///改变播放模式
  void changePlayMode(PlayMode playMode) {
    _player.transportControls.setPlayMode(playMode);

    print('change play mode to:$playMode');

    //延迟刷新，防止UI卡顿
    Future.delayed(
        const Duration(milliseconds: 200), () => this.add(PlayEve.reload));
  }

  ///刷新播放内容与播放计时器
  void _update({MusicMetadata data}) {
    try {
      if (data != null)
        _musicPlayer.data = data;
      else
        _musicPlayer.data = _player.metadata;

      if (_updateLock) {
        ///开锁
        _updateLock = false;

        //延迟刷新,阻断监听更新,防止UI卡顿
        Future.delayed(const Duration(milliseconds: 500), () {
          print('刷新播放内容');

          ///关锁
          _updateLock = true;

          this.add(PlayEve.reload);
        });

        final _state = _player.playbackState.state;

        ///根据播放状态判断是否开始计时
        if (_state == PlayerState.Playing || _state == PlayerState.None) {
          ///
          if (_timer == null || !_timer.isActive) {
            print('开始计时');

            _musicPlayer.state = PlayerState.Playing;

            _timer = Timer.periodic(const Duration(seconds: 1), (t) {
              BlocProvider.of<IndicatorBloc>(_context).changeIndicator(
                  _player.value.playbackState.computedPosition,
                  _musicPlayer.data?.duration ?? 10000);
            });
          }
        } else {
          print('关闭计时器');

          _timer?.cancel();
        }
      }
    } catch (e) {
      print('刷新数据失败:$e');
    }
  }

  ///释放播放器
  Future<void> destroy() async {
    _player.dispose();
  }

  @override
  Stream<PlayMag> mapEventToState(PlayEve event) async* {
    yield state.copyWith(musicPlayer: _musicPlayer);
  }
}
