import 'package:flutter/material.dart';
import './controls/controls.dart';
import './widgets/widgets.dart';

abstract class JsonGenFormInterface {
  dynamic validate();
  dynamic getFieldValue(String field);
  void setFieldValue(String field, dynamic value);
}

class JsonGenForm extends StatefulWidget {
  final dynamic config;
  final double groupSpace;
  final double fieldSpace;
  final Future<String> Function(String filePath, String field)? uploadFile;

  const JsonGenForm({
    super.key,
    this.config,
    this.groupSpace = 10,
    this.fieldSpace = 10,
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
    final List<dynamic> config = widget.config;

    return Form(
      key: _formKey,
      child: Column(
        children: config.map((item) {
          final isLast = config.indexOf(item) == config.length - 1;
          final isGroup = item['type'] == 'group';

          if (isGroup) {
            return _buildGroup(item, isLast);
          }

          return Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : widget.groupSpace),
            child: _buildField(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroup(Map<String, dynamic> group, bool isLast) {
    String? groupLabel = group['label'] ?? '';
    String? groupField = group['field'] ?? '';
    bool hiddenLabel = group['hiddenLabel'] == true;
    List<dynamic> children = group['children'] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : widget.groupSpace),
      child: Column(
        children: [
          FieldLabel(label: groupLabel, hiddenLabel: hiddenLabel),
          ...children.map((item) {
            final isLast = children.indexOf(item) == children.length - 1;
            if (groupField != '') {
              item['field'] = '$groupField.${item['field']}';
            }

            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : widget.fieldSpace),
              child: _buildField(item),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> config) {
    final type = config['type'];

    String field = config['field'];
    dynamic value = config['value'];
    if (value != null) {
      _onChanged(field, value);
    }

    switch (type) {
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
        return Text('日期时间选择器');
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

  _onChanged(String field, dynamic value) {
    List<String> fields = field.split('.');
    _data[fields[0]] = _data[fields[0]] ?? {};
    if (fields.length == 1) {
      _data[fields[0]] = value;
    } else {
      _data[fields[0]][fields[1]] = value;
    }
    print('onChanged $_data');
  }

  @override
  dynamic validate() async {
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
