import 'package:flutter/foundation.dart';
import 'package:light_player/objects/lp_music.dart';

///关于音乐的一些耗时操作
class PlayHelper {
  ///移除指定类型的音乐
  static Future<List<LpMusic>> asyncRemoveTypeMusic(
      List<LpMusic> list, MusicType type) async {
    return await compute(_removeTypeMusic, [list, type]);
  }

  ///移除指定类型的音乐的核心方法
  static List<LpMusic> _removeTypeMusic(List<dynamic> data) {
    final List<LpMusic> _list = data[0] as List<LpMusic>;
    final MusicType _type = data[1] as MusicType;

    _list.removeWhere((m) => m.musicType == _type);

    return _list;
  }

  ///从播放列表中抽取指定类型，指定来源的音乐
  static Future<List<LpMusic>> asyncGetTypeMusic(
      List<LpMusic> playList, MusicType musicType) async {
    return await compute(_getTypeMusic, [playList, musicType]);
  }

  ///从播放列表中抽取指定类型，指定来源的音乐的核心方法
  static List<LpMusic> _getTypeMusic(List<dynamic> data) {
    final List<LpMusic> _playList = data[0] as List<LpMusic>;
    final MusicType _musicType = data[1] as MusicType;

    final _tempList = _playList.where((p) => p.musicType == _musicType);

    return List<LpMusic>.from(_tempList);
  }

  ///在播放列表中寻找指定条件的音乐索引
  static Future<int> asyncGetMusicIndex(
      List<LpMusic> list, LpMusic music) async {
    return await compute(_getMusicIndex, [list, music]);
  }

  static int _getMusicIndex(data) {
    final List<LpMusic> _list = data[0] as List<LpMusic>;
    final LpMusic music = data[1] as LpMusic;

    return _list.indexWhere((m) => m.isSame(music));
  }
}
