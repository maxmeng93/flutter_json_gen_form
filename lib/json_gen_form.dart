import 'package:flutter/material.dart';
import './controls/controls.dart';
import './widgets/widgets.dart';

class JsonGenForm extends StatefulWidget {
  final dynamic config;
  final double groupSpace;
  final double fieldSpace;

  const JsonGenForm({
    super.key,
    this.config,
    this.groupSpace = 10,
    this.fieldSpace = 10,
  });

  @override
  State<JsonGenForm> createState() => JsonGenFormState();
}

class JsonGenFormState extends State<JsonGenForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  @override
  Widget build(BuildContext context) {
    final List<dynamic> config = widget.config;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff222124),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        // onChanged: () {
        //   print('formField onChanged');
        // },
        child: Column(
          children: [
            ...config.map((item) {
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
            ElevatedButton(
              onPressed: () {
                final formState = _formKey.currentState as FormState;
                formState.save();
                if (formState.validate()) {
                  formState.save();
                  print('提交成功');
                }
              },
              child: const Text('提交'),
            ),
          ],
        ),
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
      case 'cascader':
        return Text('级联选择器');
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
        return MediaControl(data: config, onChanged: _onChanged);
      default:
        return Container();
    }
  }

  _onChanged(String field, dynamic value) {
    List<String> fields = field.split('.');
    setState(() {
      _data[fields[0]] = _data[fields[0]] ?? {};
      if (fields.length == 1) {
        _data[fields[0]] = value;
      } else {
        _data[fields[0]][fields[1]] = value;
      }

      print('onChanged $_data');
    });
  }
}
