import 'package:flutter/material.dart';

typedef Wrapper = Widget Function(Widget child, dynamic config);

class JsonGenFormDecoration {
  final Wrapper? groupWrap;
  final Wrapper? groupLabelWrap;
  final TextStyle? groupLabelStyle;

  final Wrapper? rowWrap;

  final Wrapper? controlWrap;
  final Wrapper? controlLabelWrap;
  final TextStyle? controlLabelStyle;

  final InputDecoration? inputDecoration;

  const JsonGenFormDecoration({
    this.groupWrap,
    this.groupLabelWrap,
    this.groupLabelStyle,
    this.rowWrap,
    this.controlWrap,
    this.controlLabelWrap,
    this.controlLabelStyle,
    this.inputDecoration,
  });
}

class JsonGenFormModel with ChangeNotifier {
  JsonGenFormDecoration? _decoration;
  JsonGenFormDecoration? get decoration => _decoration;

  set decoration(JsonGenFormDecoration? data) {
    _decoration = data;
    notifyListeners();
  }
}
