import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/search_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';
import 'package:light_player/helpers/font_icon.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/objects/lp_style.dart';
import 'package:light_player/util/app_util.dart';
import 'package:light_player/widgets/lp_leading.dart';

class MusicSearchHeader extends StatefulWidget {
  ///ScrollController
  final ScrollController controller;

  final Function(String) onSearch;

  final TextEditingController textEditingController;

  const MusicSearchHeader(
      {Key key,
      @required this.controller,
      @required this.onSearch,
      @required this.textEditingController})
      : super(key: key);

  @override
  _MusicSearchHeaderState createState() => _MusicSearchHeaderState();
}

class _MusicSearchHeaderState extends State<MusicSearchHeader> {
  ///控件Key,用于获取FlexibleAppBar的高度
  GlobalKey _globalKey;

  ///状态栏显示模式控制
  bool _light = true;

  ///搜索框焦点
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _globalKey = GlobalKey();
    _focusNode = FocusNode();

    _onTextFieldTap();

    _autoFocus();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listenHeadScroll);

    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.removeListener(_listenHeadScroll);

    widget.controller.addListener(_listenHeadScroll);
  }

  ///延时自动获焦,防止UI卡顿
  _autoFocus() async => await Future.delayed(Duration(milliseconds: 500),
      () => FocusScope.of(context).requestFocus(_focusNode));

  ///监听头部折叠状态并改变状态栏颜色模式
  _listenHeadScroll() {
    if (_globalKey.currentContext.size.height < 110 && _light) {
      setState(() {
        _light = false;
      });
    } else if (_globalKey.currentContext.size.height > 110 && !_light) {
      setState(() {
        _light = true;
      });
    }
  }

  ///点击文本输入框
  _onTextFieldTap() async {
    BlocProvider.of<SearchBloc>(context).changeState(SearchState.history);
    if (widget.controller.offset < Lp.w(100)) {
      final double _nowOffset = widget.controller.offset;
      await Future.delayed(Duration(milliseconds: 300), () {});
      await widget.controller.animateTo(_nowOffset + Lp.w(100),
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
  }

  ///清空输入框内容，若内容为空，则退出
  _clearOrExit() async {
    if (widget.textEditingController.text != null &&
        widget.textEditingController.text.length > 0) {
      widget.textEditingController.clear();
      FocusScope.of(context).requestFocus(_focusNode);
      _onTextFieldTap();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: _light ? Brightness.dark : Brightness.light,
      elevation: 0.0,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: Lp.screenHeightDp * 0.5,
      flexibleSpace: FlexibleSpaceBar(
        key: _globalKey,
        centerTitle: true,
        titlePadding: EdgeInsets.zero,
        title: _searchBox,
        background: _titleBg,
      ),
    );
  }

  ///头部标题与背景
  Widget get _titleBg {
    return BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
      return Hero(
        tag: 'search',
        child: Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(s.style.globalRadius),
          ),
          child: Stack(
            children: <Widget>[
              ///背景图片
              Image.asset(
                'images/func1.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              ///背景遮罩
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.7),
              ),

              ///上层控件
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      AppL.of(context).translate('search') +
                          "  " +
                          AppL.of(context).translate('music_w').toLowerCase(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.display4.color,
                        fontSize: Lp.sp(100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildMusicType,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ///构建音乐类型选项
  Widget get _buildMusicType => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Lp.w(80),
          vertical: Lp.w(100),
        ),
        child: SizedBox(
          height: Lp.w(200),
          child: BlocBuilder<StyleBloc, StyleMag>(
            builder: (c, s) => ClipRRect(
              borderRadius: BorderRadius.circular(s.style.globalRadius),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (c, index) => _buildMusicTypeItem(index, s.style),
                separatorBuilder: (c, i) => SizedBox(width: Lp.w(40)),
              ),
            ),
          ),
        ),
      );

  ///构建搜索水平音乐资源类型列表
  Widget _buildMusicTypeItem(int index, LpStyle style) {
    ///每种类型的图标
    final List<IconData> _source = [
      //Lp本地
      Entypo.feather,
      //Netsase
      FontIcons.netsaseMusic,
      //QQ
      FontIcons.qqMusic,
      //Kugou
      FontIcons.kugouMusic,
      //Xiami
      FontIcons.xiamiMusic,
    ];

    ///每种类型的名称
    final List<String> _sourceTitle = [
      AppL.of(context).translate('local'),
      AppL.of(context).translate('netease').split(' ')[0],
      AppL.of(context).translate('qq').split(' ')[0],
      AppL.of(context).translate('kugou').split(' ')[0],
      AppL.of(context).translate('xiami').split(' ')[0],
    ];

    return SizedBox(
      width: Lp.w(200),
      child: BlocBuilder<SearchBloc, SearchMag>(builder: (c, s) {
        final bool _isSelection =
            s.sourceTypes.indexOf(SourceType.values[index]) > -1;

        return ChoiceChip(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(style.globalRadius)),
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          selectedColor: Theme.of(context).textTheme.display4.color,
          backgroundColor: Theme.of(context).canvasColor,
          selected: _isSelection,
          label: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _source[index],
                  color: _isSelection
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).accentColor,
                ),
                Text(
                  _sourceTitle[index],
                  style: TextStyle(
                    fontSize: Lp.sp(30),
                    height: 2.0,
                  ),
                ),
              ],
            ),
          ),
          onSelected: (select) async {
            await BlocProvider.of<SearchBloc>(context)
                .changeSearchType(SourceType.values[index]);
          },
        );
      }),
    );
  }

  ///搜索框
  Widget get _searchBox {
    return Container(
      alignment: Alignment.center,
      width: Lp.screenWidthDp / 1.57,
      height: kToolbarHeight,
      child: BlocBuilder<StyleBloc, StyleMag>(
        builder: (c, s) {
          return Hero(
            tag: 'search_box',
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(s.style.globalRadius),
              color: Theme.of(context).canvasColor,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  children: <Widget>[
                    LpLeading(size: Lp.w(40)),
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        focusNode: _focusNode,
                        controller: widget.textEditingController,
                        textInputAction: TextInputAction.search,
                        scrollPadding:
                            EdgeInsets.symmetric(horizontal: Lp.w(40)),
                        style: TextStyle(fontSize: Lp.sp(30)),
                        textAlign: TextAlign.center,
                        cursorRadius: Radius.circular(10),
                        cursorWidth: 1.0,
                        scrollPhysics: BouncingScrollPhysics(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onSubmitted: widget.onSearch ?? () => null,
                        onTap: _onTextFieldTap,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Feather.x,
                        size: Lp.w(40),
                      ),
                      onPressed: _clearOrExit,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
