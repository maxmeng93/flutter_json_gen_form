import 'package:flutter/material.dart';

typedef Wrapper = Widget Function(Widget child, dynamic config);

class JsonGenFormDecoration {
  final Wrapper? groupWrap;
  final Wrapper? groupLabelWrap;
  final Wrapper? rowWrap;
  final Wrapper? controlWrap;
  final Wrapper? controlLabelWrap;

  const JsonGenFormDecoration({
    this.groupWrap,
    this.groupLabelWrap,
    this.rowWrap,
    this.controlWrap,
    this.controlLabelWrap,
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
