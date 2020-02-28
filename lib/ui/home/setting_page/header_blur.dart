import 'dart:ui';

import 'package:flutter/material.dart';

class HeaderBlur extends StatefulWidget {
  final ScrollController controller;

  const HeaderBlur({Key key, @required this.controller}) : super(key: key);

  @override
  _HeaderBlurState createState() => _HeaderBlurState();
}

class _HeaderBlurState extends State<HeaderBlur> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_scrollRefresh);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_scrollRefresh);
    super.dispose();
  }

  _scrollRefresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: widget.controller.offset.abs() / 10,
        sigmaY: widget.controller.offset.abs() / 10,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor.withOpacity(0.4),
      ),
    );
  }
}
