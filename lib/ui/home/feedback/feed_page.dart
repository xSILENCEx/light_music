import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:light_player/bloc/app_bloc.dart';
import 'package:light_player/bloc/style_bloc.dart';
import 'package:light_player/helpers/app_local.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Feather.menu),
          onPressed: () => BlocProvider.of<AppBloc>(context)
              .drawerKey
              .currentState
              .openDrawer(),
        ),
        title: Text(
          AppL.of(context).translate('feedback').toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<StyleBloc, StyleMag>(
        builder: (c, s) {
          return Material(
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(s.style.globalRadius)),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[],
            ),
          );
        },
      ),
    );
  }
}
