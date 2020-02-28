import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/bloc/playing_bloc.dart';
import 'package:light_player/auxiliary/bloc/style_bloc.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/others/font_icon.dart';
import 'package:light_player/auxiliary/util/app_util.dart';
import 'package:light_player/objects/lp_music.dart';
import 'package:light_player/objects/lp_style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

///音乐项
class MusicItem extends StatelessWidget {
  const MusicItem({
    Key key,
    @required this.index,
    @required this.currentMusicList,
  }) : super(key: key);

  ///索引
  final int index;

  ///当前界面的音乐列表
  final List<LpMusic> currentMusicList;

  @override
  Widget build(BuildContext context) => _innerBox(context);

  ///播放该曲目
  Future<void> _play(BuildContext context) async =>
      await BlocProvider.of<PlayBloc>(context).play(
        currentMusicList[index],
        isAuto: false,
        list: currentMusicList,
      );

  ///显示选项菜单
  _showOption(BuildContext context) {
    Lp.showContentDialog(
        context, _optionItems, AppL.of(context).translate('more_fun_info'));
  }

  ///选项菜单
  Widget get _optionItems {
    final List<IconData> _icons = [
      Feather.arrow_down,
      Feather.share,
      Feather.folder,
      AntDesign.info,
    ];

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _icons
          .map((i) => SizedBox(
                width: Lp.w(160),
                height: Lp.w(160),
                child: BlocBuilder<StyleBloc, StyleMag>(builder: (c, s) {
                  return FlatButton(
                    color: Theme.of(c).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(s.style.globalRadius * 0.8)),
                    onPressed: () => Navigator.pop(c),
                    child: Icon(
                      i,
                      size: Lp.w(60),
                      color: Theme.of(c).textTheme.display4.color,
                    ),
                  );
                }),
              ))
          .toList(),
    );
  }

  ///头部控件
  Widget _leadingState(BuildContext context, LpStyle style, bool isSame) {
    final List<Widget> _leadings = [
      ///常态显示数字
      Container(
        alignment: Alignment.center,
        width: Lp.w(120),
        height: Lp.w(120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(style.globalRadius * 0.8),
          color: Theme.of(context).disabledColor.withOpacity(0.1),
        ),
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: Lp.sp(40),
            fontWeight: FontWeight.w800,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),

      ///播放中显示波形
      Container(
        alignment: Alignment.center,
        width: Lp.w(120),
        height: Lp.w(120),
        child: Icon(
          Entypo.air,
          size: Lp.w(50.0),
          color: Theme.of(context).primaryColor,
        ),
      ),

      ///暂停显示两道杠
      Container(
        alignment: Alignment.center,
        width: Lp.w(120),
        height: Lp.w(120),
        child: Icon(
          Entypo.controller_paus,
          size: Lp.w(50.0),
          color: Theme.of(context).primaryColor,
        ),
      ),

      ///下载
      Container(
        alignment: Alignment.center,
        width: Lp.w(120),
        height: Lp.w(120),
        child: CircularPercentIndicator(
          radius: 40,
          percent: 0.6,
          animation: true,
          progressColor: Theme.of(context).accentColor,
          backgroundColor: Colors.transparent,
          addAutomaticKeepAlive: false,
          animateFromLastPercent: true,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ),
    ];

    if (isSame) {
      final AudioPlayerState state =
          BlocProvider.of<PlayBloc>(context).getAudioPlayerState;

      //如果正在播放
      if (state == AudioPlayerState.PLAYING) return _leadings[1];

      //其它情况
      return _leadings[2];
    }

    return _leadings[0];
  }

  ///尾标
  Widget _trailing(BuildContext context, LpStyle s, bool isSame) {
    ///每种类型的图标
    final List<IconData> _source = [
      //Lp
      Entypo.feather,
      //Netease
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
      AppL.of(context).translate('netease'),
      AppL.of(context).translate('qq'),
      AppL.of(context).translate('kugou'),
      AppL.of(context).translate('xiami'),
    ];

    return Material(
      animationDuration: const Duration(seconds: 1),
      color: currentMusicList[index].pay
          ? isSame
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.display4.color
          : Theme.of(context).disabledColor,
      borderRadius: BorderRadius.circular(s.globalRadius * 0.4),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Lp.w(10), horizontal: Lp.w(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              _source[currentMusicList[index].sourceType.index],
              size: Lp.sp(28.0),
              color: isSame
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).primaryColor,
            ),
            Text(
              _sourceTitle[currentMusicList[index].sourceType.index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSame
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).primaryColor,
                fontSize: Lp.sp(26.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///上层内容
  Widget _innerBox(BuildContext context) => BlocBuilder<StyleBloc, StyleMag>(
        builder: (c, s) => BlocBuilder<PlayBloc, PlayMag>(
          builder: (pc, play) {
            final _isSame =
                play.musicPlayer.currentMusic.isSame(currentMusicList[index]);

            return Material(
              clipBehavior: Clip.antiAlias,
              animationDuration: const Duration(seconds: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(s.style.globalRadius),
              ),
              color: Colors.transparent,
              child: AnimatedContainer(
                color: _isSame
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
                duration: Duration(milliseconds: 800),
                curve: Curves.ease,
                child: ListTile(
                  dense: false,
                  enabled: currentMusicList[index].pay,
                  contentPadding: EdgeInsets.symmetric(horizontal: Lp.w(30)),
                  leading: _leadingState(context, s.style, _isSame),
                  title: Text(
                    currentMusicList[index].musicName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: play.musicPlayer.currentMusic
                              .isSame(currentMusicList[index])
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).iconTheme.color,
                      fontSize: Lp.sp(36.0),
                      fontWeight: play.musicPlayer.currentMusic
                              .isSame(currentMusicList[index])
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    currentMusicList[index].getSinger(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: play.musicPlayer.currentMusic
                              .isSame(currentMusicList[index])
                          ? Theme.of(context).primaryColor.withOpacity(0.6)
                          : Theme.of(context).iconTheme.color.withOpacity(0.6),
                      fontSize: Lp.sp(30.0),
                    ),
                  ),
                  trailing: _trailing(context, s.style, _isSame),
                  onTap: () async => await _play(context),
                  onLongPress: () => _showOption(context),
                ),
              ),
            );
          },
        ),
      );
}
