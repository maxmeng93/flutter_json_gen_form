library json_gen_form;

import 'package:flutter/material.dart';
import './controls/controls.dart';
import './layouts/layouts.dart';
import './theme.dart';

class JsonGenFormDecoration {
  final Widget Function(Widget child)? groupWrapper;
  final Widget Function({
    String field,
    String upField,
    String label,
    Widget child,
  })? groupLabelWrapper;
  final Widget Function(Widget child)? rowWrapper;
  final Widget Function({
    String field,
    String upField,
    String label,
    bool required,
    Widget child,
  })? fieldLabelWrapper;

  const JsonGenFormDecoration({
    this.groupWrapper,
    this.groupLabelWrapper,
    this.rowWrapper,
    this.fieldLabelWrapper,
  });
}

abstract class JsonGenFormInterface {
  dynamic validate();
  dynamic getFieldValue(String field);
  void setFieldValue(String field, dynamic value);
}

class JsonGenForm extends StatefulWidget {
  final dynamic config;
  final JsonGenFormDecoration? decoration;
  final ThemeData? theme;
  final Future<String> Function(String filePath, String field)? uploadFile;

  const JsonGenForm({
    super.key,
    this.config,
    this.decoration,
    this.theme,
    this.uploadFile,
  });

  @override
  State<JsonGenForm> createState() => JsonGenFormState();
}

class JsonGenFormState extends State<JsonGenForm>
    implements JsonGenFormInterface {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  @override
  Widget build(BuildContext context) {
    ThemeData theme = widget.theme ?? JsonGenFormTheme.getTheme(context);
    final List<dynamic> config = widget.config;

    return Theme(
      data: theme,
      child: Form(
        key: _formKey,
        child: Column(
          children: config.map((item) => _buildField(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> config) {
    final type = config['type'];

    switch (type) {
      case 'group':
        return GroupLayout(data: config, buildField: _buildField);
      case 'row':
        return RowLayout(data: config, buildField: _buildField);
      case 'text':
      case 'password':
      case 'textarea':
      case 'number':
        return InputControl(data: config, onChanged: _onChanged);
      case 'select':
        return SelectControl(data: config, onChanged: _onChanged);
      case 'cascade':
        return CascadeControl(data: config, onChanged: _onChanged);
      case 'radio':
        return RadioControl(data: config, onChanged: _onChanged);
      case 'checkbox':
        return CheckboxControl(data: config, onChanged: _onChanged);
      case 'switch':
        return SwitchControl(data: config, onChanged: _onChanged);
      case 'date':
      case 'time':
      case 'datetime':
        return DatetimeControl(data: config, onChanged: _onChanged);
      case 'media':
        return MediaControl(
          data: config,
          onChanged: _onChanged,
          uploadFile: widget.uploadFile,
        );
      default:
        return Container();
    }
  }

  void _onChanged(String field, dynamic value) {
    List<String> keys = field.split('.');
    Map<String, dynamic> cur = _data;

    for (int i = 0; i < keys.length - 1; i++) {
      if (cur[keys[i]] == null || cur[keys[i]] is! Map<String, dynamic>) {
        cur[keys[i]] = <String, dynamic>{};
      }
      cur = cur[keys[i]];
    }

    cur[keys.last] = value;

    debugPrint('data: $_data');
  }

  @override
  dynamic validate() {
    final formState = _formKey.currentState as FormState;
    if (formState.validate()) {
      return _data;
    }
    return false;
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
    _onChanged(field, value);
  }
}
