import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_player/helpers/follow_music_helper.dart';
import 'package:light_player/helpers/local_music_helper.dart';
import 'package:light_player/objects/lp_music.dart';

enum SearchEnv { reload }

///搜索管理器
class SearchMag {
  ///历史记录列表
  final List<String> hisList;

  ///搜索页面状态
  final SearchState searchState;

  ///要搜索的音乐类型
  final List<SourceType> sourceTypes;

  const SearchMag({
    this.hisList = const <String>[],
    this.searchState = SearchState.history,
    this.sourceTypes = const [],
  });

  SearchMag copyWith({
    final List<String> hisList,
    final SearchState searchState,
    final List<SourceType> sourceTypes,
  }) {
    return SearchMag(
      hisList: hisList ?? this.hisList,
      searchState: searchState ?? this.searchState,
      sourceTypes: sourceTypes ?? this.sourceTypes,
    );
  }
}

///搜索管理器
class SearchBloc extends Bloc<SearchEnv, SearchMag> {
  List<String> _hisList = List<String>();

  SearchState _searchState = SearchState.history;

  List<SourceType> _sourceTypes = List<SourceType>.from([SourceType.local]);

  ///中断搜索进程的锁
  bool searchLocked = false;

  @override
  SearchMag get initialState => SearchMag(
      hisList: _hisList, searchState: _searchState, sourceTypes: _sourceTypes);

  ///初始化搜索管理器
  Future<void> init() async {
    print('初始化搜索管理器');
  }

  ///搜索
  Future<List<LpMusic>> search(String keyWord) async {
    ///添加一条历史或刷新历史位置
    _addHisItem(keyWord);

    this.changeState(SearchState.loading);
    print('开始搜索');

    List<LpMusic> _tempList = List<LpMusic>();

    try {
      ///搜索类型列表中的所有结果
      if (_checkSourceType(SourceType.local)) {
        _tempList.addAll(await LocalMusicHelper.searchMusic(keyWord));
        print('Local搜索完毕，当前长度:${_tempList.length}');
      }
      if (_checkSourceType(SourceType.netease)) {
        print('Netease搜索完毕，当前长度:${_tempList.length}');
      }
      if (_checkSourceType(SourceType.qq)) {
        _tempList.addAll(await QQMusicHelper.searchQQMusic(keyWord));
        print('QQ搜索完毕，当前长度:${_tempList.length}');
      }
      if (_checkSourceType(SourceType.kugou)) {
        print('Kugou搜索完毕，当前长度:${_tempList.length}');
      }
      if (_checkSourceType(SourceType.xiami)) {
        print('Xiami搜索完毕，当前长度:${_tempList.length}');
      }

      ///搜索进程可以被中断
      if (!searchLocked) {
        if (_tempList.isEmpty)
          this.changeState(SearchState.empty);
        else
          this.changeState(SearchState.musicList);

        print('搜索完毕');
      }
    } catch (e) {
      print('搜索音乐出错:$e');
      this.changeState(SearchState.error);
    }

    return _tempList ?? [];
  }

  ///增加一条历史记录
  Future<void> _addHisItem(String his) async {
    this._hisList.remove(his);
    this._hisList.add(his);
  }

  ///删除一条历史记录
  Future<void> removeHisItem(String his) async {
    this._hisList.remove(his);
    this.add(SearchEnv.reload);
  }

  ///清除历史记录
  Future<void> cleanHisItem() async {
    this._hisList.clear();
    this.add(SearchEnv.reload);
  }

  ///检测是否有传入的搜索类型
  bool _checkSourceType(SourceType type) {
    return this._sourceTypes.indexOf(type) != -1;
  }

  ///改变搜索类型
  Future<void> changeSearchType(SourceType musicType) async {
    _checkSourceType(musicType)
        ? this._sourceTypes.removeWhere((m) => musicType == m)
        : this._sourceTypes.add(musicType);

    print('剩余搜索音乐类型:${this._sourceTypes}');

    await Future.delayed(
        Duration(milliseconds: 300), () => this.add(SearchEnv.reload));
  }

  ///刷新搜索页面状态
  void changeState(SearchState state) {
    if (this._searchState != state) {
      if (state == SearchState.loading)
        searchLocked = false;
      else
        searchLocked = true;

      this._searchState = state;
      this.add(SearchEnv.reload);
    }
  }

  @override
  Stream<SearchMag> mapEventToState(SearchEnv event) async* {
    yield state.copyWith(
      hisList: _hisList,
      searchState: _searchState,
      sourceTypes: _sourceTypes,
    );
  }
}
