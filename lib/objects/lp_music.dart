///音乐类型
///* [local]本地音乐
///* [follow]随缘音乐
enum MusicType { local, follow }

///音乐下载状态
///* [download]已下载
///* [downloading]正在下载
///* [not_download]未下载
enum DownLoadState { not_download, download, downloading }

///网络音乐资源来源
///* [local]    本地
///* [netease]  网易
///* [qq]       QQ
///* [kugou]    酷狗
///* [xiami]    虾米
enum SourceType { local, netease, qq, kugou, xiami }

///音乐列表状态
///* [loading]  正在加载
///* [list]     显示列表
///* [empty]    显示空视图
///* [error]    显示错误页面
enum ListState { loading, list, empty, error }

///搜索页面状态
/// * [musicList] 显示结果
/// * [history] 显示历史记录
/// * [empty] 空页面
/// * [error] 错误页面
/// * [loading] 正在加载
enum SearchState { musicList, history, empty, error, loading }

class LpMusic {
  ///音乐在播放器中的唯一标识
  final String musicID;

  ///原始数据
  final Map originalData;

  ///音乐列表种类，暂定2种
  final MusicType musicType;

  ///资源类型
  final SourceType sourceType;

  ///歌曲songmid,用于获取token与播放链接
  final String songMid;

  ///名称
  final String musicName;

  ///歌手
  final List<String> singers;

  ///专辑名
  final String album;

  ///时长
  final int duration;

  ///播放链接
  final String sourceUrl;

  ///封面链接
  final String coverUrl;

  ///下载状态
  DownLoadState downLoadState;

  ///下载进度
  double downloadProgress;

  ///是否收藏
  bool isCollection;

  ///文件路径
  String filePath;

  ///是否可用,默认为true:可用
  bool pay;

  LpMusic(
    this.musicID,
    this.songMid,
    this.originalData,
    this.musicType,
    this.musicName,
    this.singers,
    this.album,
    this.duration,
    this.sourceUrl,
    this.coverUrl, {
    this.sourceType = SourceType.local,
    this.downLoadState = DownLoadState.download,
    this.downloadProgress = 0.0,
    this.isCollection = false,
    this.filePath,
    this.pay = true,
  });

  ///生成默认音乐
  static LpMusic def() {
    return LpMusic(
      'musicID',
      'songMid',
      {},
      MusicType.local,
      'musicName',
      ['singers'],
      'album',
      0,
      'sourceUrl',
      'http://img04.taobaocdn.com/bao/uploaded/i4/TB2JOnSspXXXXbzXXXXXXXXXXXX_!!2080097744.jpg',
    );
  }

  ///获取歌手
  String getSinger() {
    return this
        .singers
        .toString()
        .replaceAll(',', '/')
        .replaceAll(']', '')
        .replaceAll('[', '');
  }

  ///判断是否是同一首歌
  bool isSame(LpMusic music) {
    return music.songMid == this.songMid;
  }
}
