import 'package:flutter/material.dart';

typedef Wrapper = Widget Function(Widget child, dynamic config);

/// 自定义整个表单及其内部分组、布局、控件的样式
class JsonGenFormDecoration {
  /// group wrapper
  final Wrapper? groupWrap;

  /// group label wrapper
  final Wrapper? groupLabelWrap;

  /// group label textStyle
  final TextStyle? groupLabelStyle;

  /// row wrapper
  final Wrapper? rowWrap;

  /// form control wrapper
  final Wrapper? controlWrap;

  /// form control label wrapper
  final Wrapper? controlLabelWrap;

  /// form control label textStyle
  final TextStyle? controlLabelStyle;

  /// form input decoration
  /// text, textarea, password, number, select, cascade, date, time, datetime
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
