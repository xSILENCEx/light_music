import 'package:light_player/auxiliary/util/dio_util.dart';
import 'package:light_player/objects/lp_music.dart';

class QQMusicHelper {
  ///在线获取qq的推荐列表
  static Future<dynamic> getRecommendQQMusic({bool isTop = false}) async {
    ///获取原始数据
    final List<dynamic> _qqListData = (await DioUtils.getRecommendMusic(
            SourceType.qq,
            isTop: isTop))['songlist'] ??
        [];

    if (_qqListData.isNotEmpty) {
      ///从原始数据中解析出数据并加入播放列表
      return _qqListData
          .map(
            (m) => LpMusic(
              'follow${_qqListData.indexOf(m)}',
              m['data']['songmid'],
              m['data'],
              MusicType.follow,
              m['data']['songname'],
              _getQQMusicSinger(m['data']['singer']),
              m['data']['albumname'],
              m['data']['interval'],
              '',
              _getQQCover(m['data']['albumid']),
              sourceType: SourceType.qq,
              downLoadState: DownLoadState.not_download,
              pay: m['data']['pay']['payplay'] != 1,
            ),
          )
          .toList();
    }

    return [];
  }

  ///获取QQ音乐搜索列表
  static Future<dynamic> searchQQMusic(String keyWord) async {
    ///获取原始数据
    final List<dynamic> _qqListData =
        (await DioUtils.searchMusic(SourceType.qq, keyWord))['data']['song']
                ['list'] ??
            [];

    if (_qqListData.isNotEmpty) {
      ///从原始数据中解析出数据并加入播放列表
      return _qqListData
          .map(
            (m) => LpMusic(
              'follow${_qqListData.indexOf(m)}',
              m['songmid'],
              m,
              MusicType.follow,
              m['songname'],
              _getQQMusicSinger(m['singer']),
              m['albumname'],
              m['interval'],
              '',
              _getQQCover(m['albumid']),
              sourceType: SourceType.qq,
              downLoadState: DownLoadState.not_download,
              pay: m['pay']['payplay'] != 1,
            ),
          )
          .toList();
    }

    return [];
  }

  ///获取qq音乐的播放地址
  static Future<String> getQQPlayUrl(String songmid) async {
    final String _tokenUrl =
        "https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?format=json205361747&platform=yqq&cid=205361747&songmid=$songmid&filename=C400$songmid.m4a&guid=126548448";

    final Map result =
        await DioUtils.request(_tokenUrl, '获取qq音乐的播放地址与时长', log: false);

    ///检查vkey
    final String vkey = result['data']['items'][0]['vkey'];
    if (vkey.length == 0) {
      return '';
    }

    return "http://ws.stream.qqmusic.qq.com/C400$songmid.m4a?fromtag=0&guid=126548448&vkey=$vkey";
  }

  ///获取qq歌手列表
  static List<String> _getQQMusicSinger(List<dynamic> sList) {
    List<String> singerList = List<String>();
    sList.forEach((s) {
      singerList.add(s['name']);
    });

    if (singerList.isEmpty) {
      singerList.add('未知歌手');
    }

    return singerList;
  }

  ///获取qq音乐封面
  static String _getQQCover(int albumid) {
    return "http://imgcache.qq.com/music/photo/album_300/${albumid % 100}/300_albumpic_${albumid}_0.jpg";
  }
}

// class QQTest {
//   Map tn = {
//     "Franking_value": "11",
//     "cur_count": "11",
//     "data": {
//       "albumdesc": "",
//       "albumid": 1666157,
//       "albummid": "000jE4g74VS43p",
//       "albumname": "无法长大",
//       "alertid": 2,
//       "belongCD": 6,
//       "cdIdx": 0,
//       "interval": 328,
//       "isonly": 0,
//       "label": "4611686018435776769",
//       "msgid": 14,
//       "pay": {
//         "payalbum": 1,
//         "payalbumprice": 1600,
//         "paydownload": 1,
//         "payinfo": 1,
//         "payplay": 0,
//         "paytrackmouth": 1,
//         "paytrackprice": 200,
//         "timefree": 0
//       },
//       "preview": {"trybegin": 83160, "tryend": 116143, "trysize": 0},
//       "rate": 23,
//       "singer": [
//         {"id": 40449, "mid": "001Lr98T0yEWAk", "name": "赵雷"}
//       ],
//       "size128": 5249759,
//       "size320": 13124110,
//       "size5_1": 0,
//       "sizeape": 0,
//       "sizeflac": 32010277,
//       "sizeogg": 7041700,
//       "songid": 108963136,
//       "songmid": "001bhwUC1gE6ep",
//       "songname": "成都",
//       "songorig": "成都",
//       "songtype": 0,
//       "strMediaMid": "002JJDz72hlzKw",
//       "stream": 1,
//       "switch": 17413891,
//       "type": 0,
//       "vid": "m00244ktl0u"
//     },
//     "in_count": "2",
//     "old_count": "11"
//   };

//   Map tx = {
//     "Franking_value": "49",
//     "cur_count": "47",
//     "data": {
//       "albumdesc": "",
//       "albumid": 1458791,
//       "albummid": "003RMaRI1iFoYd",
//       "albumname": "周杰伦的床边故事",
//       "alertid": 41,
//       "belongCD": 8,
//       "cdIdx": 0,
//       "interval": 215,
//       "isonly": 1,
//       "label": "4611686018435776513",
//       "msgid": 13,
//       "pay": {
//         "payalbum": 1,
//         "payalbumprice": 2000,
//         "paydownload": 1,
//         "payinfo": 1,
//         "payplay": 1,
//         "paytrackmouth": 1,
//         "paytrackprice": 200,
//         "timefree": 0
//       },
//       "preview": {"trybegin": 64737, "tryend": 85668, "trysize": 960887},
//       "rate": 23,
//       "singer": [
//         {"id": 4558, "mid": "0025NhlN2yWrP4", "name": "周杰伦"}
//       ],
//       "size128": 3443771,
//       "size320": 8608859,
//       "size5_1": 0,
//       "sizeape": 0,
//       "sizeflac": 43845959,
//       "sizeogg": 5007453,
//       "songid": 107192078,
//       "songmid": "003OUlho2HcRHC",
//       "songname": "告白气球",
//       "songorig": "告白气球",
//       "songtype": 0,
//       "strMediaMid": "001pkF2E0nAO6P",
//       "stream": 1,
//       "switch": 17421569,
//       "type": 0,
//       "vid": "u00222le4ox"
//     },
//     "in_count": "2",
//     "old_count": "49"
//   };
// }
