import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/auxiliary/others/app_local.dart';
import 'package:light_player/auxiliary/util/app_util.dart';

import 'setting_item.dart';

///侧边栏选项列表
class FuncMenu extends StatelessWidget {
  const FuncMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///选项Icon名
    const List<IconData> _icons = [
      Feather.music,
      Feather.settings,
      Feather.edit,
      Feather.info,
      Feather.log_out,
    ];

    ///所有功能名称
    final List<String> _funcNames = [
      AppL.of(context).translate("music"),
      AppL.of(context).translate("setting"),
      AppL.of(context).translate("feedback"),
      AppL.of(context).translate("about"),
      AppL.of(context).translate("exit"),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Lp.w(40), vertical: Lp.w(80)),
      itemCount: _funcNames.length,
      itemBuilder: (BuildContext context, int index) => SelectItem(
        index: index,
        title: _funcNames[index],
        icon: _icons[index],
      ),
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: Lp.w(40)),
    );
  }
}
