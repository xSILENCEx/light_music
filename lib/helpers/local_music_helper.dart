import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:light_player/objects/lp_music.dart';

///本地音乐耗时操作辅助类
class LocalMusicHelper {
  ///获取全部本地音乐
  static Future<List<LpMusic>> getLocalMusicList() async {
    ///本地音乐扫描器
    final FlutterAudioQuery _audioQuery = FlutterAudioQuery();

    ///音乐信息列表
    final List<SongInfo> _musicList =
        await _audioQuery.getSongs(sortType: SongSortType.RECENT_YEAR);

    return _musicList
        .map(
          (m) => LpMusic(
            m.id,
            {},
            MusicType.local,
            m.title,
            [m.artist],
            m.album,
            Duration(milliseconds: int.parse(m.duration)).inSeconds,
            m.filePath,
            m.albumArtwork,
            sourceType: SourceType.local,
          ),
        )
        .toList();
  }

  ///搜索本地音乐
  static Future<List<LpMusic>> searchMusic(String keyWord) async {
    ///本地音乐扫描器
    final FlutterAudioQuery _audioQuery = FlutterAudioQuery();

    ///音乐信息列表
    final List<SongInfo> _musicList = await _audioQuery.searchSongs(
        query: keyWord, sortType: SongSortType.RECENT_YEAR);

    return _musicList
        .map(
          (m) => LpMusic(
            m.id,
            {},
            MusicType.local,
            m.title,
            [m.artist],
            m.album,
            Duration(milliseconds: int.parse(m.duration)).inSeconds,
            m.filePath,
            m.albumArtwork,
            sourceType: SourceType.local,
          ),
        )
        .toList();
  }

  ///通过id获取专辑的所有歌曲并转换为需要的格式
  static Future<List<LpMusic>> getAsyncSongsFromAlbum(String id) async {
    ///本地音乐扫描器
    final FlutterAudioQuery _audioQuery = FlutterAudioQuery();

    final List<SongInfo> _songInfo =
        await _audioQuery.getSongsFromAlbum(albumId: id);

    return _songInfo
        .map(
          (m) => LpMusic(
            m.id,
            {},
            MusicType.local,
            m.title,
            [m.artist],
            m.album,
            Duration(milliseconds: int.parse(m.duration)).inSeconds,
            m.filePath,
            m.albumArtwork,
            sourceType: SourceType.local,
          ),
        )
        .toList();
  }

  ///获取所有专辑
  static Future<List<AlbumInfo>> getAsyncAlbums() async {
    ///本地音乐扫描器
    final FlutterAudioQuery _audioQuery = FlutterAudioQuery();

    ///专辑信息列表
    return await _audioQuery.getAlbums(
        sortType: AlbumSortType.MOST_RECENT_YEAR);
  }

  ///获取所有歌手
  static Future<List<ArtistInfo>> getAsyncSinger() async {
    ///本地音乐扫描器
    final FlutterAudioQuery _audioQuery = FlutterAudioQuery();

    return await _audioQuery.getArtists();
  }

  ///获取歌手的音乐
  static Future<List<LpMusic>> getAsyncSingerSongs(String artist) async {
    ///本地音乐扫描器
    final FlutterAudioQuery _audioQuery = FlutterAudioQuery();

    final List<SongInfo> _songInfo =
        await _audioQuery.getSongsFromArtist(artist: artist);

    return _songInfo
        .map(
          (m) => LpMusic(
            m.id,
            {},
            MusicType.local,
            m.title,
            [m.artist],
            m.album,
            Duration(milliseconds: int.parse(m.duration)).inSeconds,
            m.filePath,
            m.albumArtwork,
            sourceType: SourceType.local,
          ),
        )
        .toList();
  }
}
