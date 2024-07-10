import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './controls/controls.dart';
import './layouts/layouts.dart';
import './utils/utils.dart' show getField;
import './theme.dart';
import './model.dart';

abstract class JsonGenFormInterface {
  /// 表单验证
  Future<dynamic> validate();

  /// 获取单个表单控件的值
  dynamic getFieldValue(String field);

  /// 设置单个表单控件的值
  void setFieldValue(String field, dynamic value);

  /// 设置整个表单的值
  void setValues(dynamic value);
}

class JsonGenForm extends StatefulWidget {
  /// json config
  final dynamic config;

  /// 自定义表单样式
  final JsonGenFormDecoration? decoration;

  /// 表单数据变化时的回调
  final void Function(Map data)? onChanged;

  /// 上传文件方法
  /// 如果不提供此方法，则多媒体等控件返回的为相对于本设备的路径
  final Future<String> Function(String filePath, String field)? uploadFile;

  const JsonGenForm({
    super.key,
    this.config,
    this.decoration,
    this.onChanged,
    this.uploadFile,
  });

  @override
  State<JsonGenForm> createState() => JsonGenFormState();
}

class JsonGenFormState extends State<JsonGenForm>
    implements JsonGenFormInterface {
  final JsonGenFormModel _model = JsonGenFormModel();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};
  final Map<String, GlobalKey> _keys = {};

  @override
  void initState() {
    super.initState();
    if (widget.decoration != null) {
      _model.decoration = widget.decoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = JsonGenFormTheme.getTheme(context);
    final List<dynamic> config = widget.config;

    return ChangeNotifierProvider.value(
      value: _model,
      child: Theme(
        data: theme,
        child: Form(
          key: _formKey,
          child: Column(
            children: config.map((item) => _buildField(item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> config) {
    GlobalKey key = GlobalKey();
    late Widget item;
    final type = config['type'];

    if (type != 'group' && type != 'row') {
      String field = getField(config);
      _keys[field] = key;
      dynamic value = config['value'];
      if (type == 'switch') {
        _setFieldValue(field, value ?? false);
      } else if (value != null) {
        _setFieldValue(field, value);
      }
    }

    switch (type) {
      case 'group':
        item = GroupLayout(data: config, buildField: _buildField);
      case 'row':
        item = RowLayout(data: config, buildField: _buildField);
      case 'text':
      case 'password':
      case 'textarea':
      case 'number':
        item = InputControl(key: key, data: config, onChanged: _onChanged);
      case 'select':
        item = SelectControl(key: key, data: config, onChanged: _onChanged);
      case 'cascade':
        item = CascadeControl(key: key, data: config, onChanged: _onChanged);
      case 'radio':
        item = RadioControl(key: key, data: config, onChanged: _onChanged);
      case 'checkbox':
        item = CheckboxControl(key: key, data: config, onChanged: _onChanged);
      case 'switch':
        item = SwitchControl(key: key, data: config, onChanged: _onChanged);
      case 'date':
      case 'time':
      case 'datetime':
        item = DatetimeControl(key: key, data: config, onChanged: _onChanged);
      case 'media':
        item = MediaControl(
          key: key,
          data: config,
          onChanged: _onChanged,
          uploadFile: widget.uploadFile,
        );
      default:
        item = Container();
    }

    return _addWrapper(config, item);
  }

  Widget _addWrapper(dynamic config, Widget child) {
    final type = config['type'];

    final decoration = widget.decoration;
    if (decoration != null) {
      if (type == 'group' && decoration.groupWrap != null) {
        return decoration.groupWrap!(child, config);
      }
      if (type == 'row' && decoration.rowWrap != null) {
        return decoration.rowWrap!(child, config);
      }
      if (decoration.controlWrap != null && type != 'group' && type != 'row') {
        return decoration.controlWrap!(child, config);
      }
    }

    return child;
  }

  /// 设置字段的值
  void _setFieldValue(String field, dynamic value) {
    List<String> keys = field.split('.');
    Map<String, dynamic> cur = _data;

    for (int i = 0; i < keys.length - 1; i++) {
      if (cur[keys[i]] == null || cur[keys[i]] is! Map<String, dynamic>) {
        cur[keys[i]] = <String, dynamic>{};
      }
      cur = cur[keys[i]];
    }

    cur[keys.last] = value;
  }

  void _onChanged(String field, dynamic value) {
    _setFieldValue(field, value);

    if (widget.onChanged != null) {
      widget.onChanged!(_data);
    }
  }

  @override
  Future<dynamic> validate() async {
    final formState = _formKey.currentState as FormState;
    if (formState.validate()) {
      return _data;
    } else {
      throw Exception("Form validation failed");
    }
  }

  @override
  dynamic getFieldValue(String field) {
    List<String> fields = field.split('.');
    if (fields.length == 1) {
      return _data[fields[0]];
    } else if (fields.length == 2) {
      if (_data[fields[0]] == null) {
        return null;
      }
      return _data[fields[0]][fields[1]];
    }
  }

  @override
  void setFieldValue(String field, dynamic value) {
    _setFieldValue(field, value);
    final state = _keys[field]?.currentState as ControlInterface;
    state.setValue(value);
  }

  @override
  void setValues(dynamic values) {
    _getControlField(values, '', (String field, dynamic value) {
      final state = _keys[field]?.currentState as ControlInterface;
      state.setValue(value);
    });
  }

  /// 递归获取控件字段
  void _getControlField(
    Map<String, dynamic> obj,
    String path,
    Function callback,
  ) {
    obj.forEach((key, value) {
      var fullPath = path.isEmpty ? key : '$path.$key';
      if (value is Map<String, dynamic>) {
        _getControlField(value, fullPath, callback);
      } else {
        callback(fullPath, value);
      }
    });
  }
}
