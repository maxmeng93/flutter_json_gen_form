import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';

enum InputType {
  text,
  password,
  textarea,
  number,
}

/// 输入框
///
/// 属性：
/// data
///  - type: 输入框类型，text | password | textarea | number
///  - field: 字段名
///  - label: 标签文案
///  - placeholder: 占位符文案
///  - value: 初始值
///  - readonly: 是否只读
///  - disabled: 是否禁用
///  - rules: 校验规则
///
/// 支持的类型：
///   - text 文本输入
///   - password 密码输入，输入内容会被隐藏
///   - textarea 多行文本输入
///   - number 数字输入，键盘类型为数字，且提交时会自动转为数字
///
class InputControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const InputControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<InputControl> createState() => _InputControlState();
}

class _InputControlState extends State<InputControl> {
  final FocusNode _focusNode = FocusNode();
  InputType type = InputType.text;
  late String field;
  String? label;
  String? placeholder;
  String? initialValue = '';
  bool obscureText = false;
  bool required = false;
  int? minLines = 1;
  int? maxLines = 1;
  bool readonly = false;
  bool disabled = false;
  List<dynamic>? rules;
  TextInputType? keyboardType;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _initData() {
    setState(() {
      final data = widget.data;

      rules = data['rules'];
      required = rules?.any((item) => item['required'] == true) ?? false;

      final typeStr = data['type'];
      for (var item in InputType.values) {
        if (item.name == typeStr) {
          type = item;
          break;
        }
      }

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;

      field = getField(data);
      label = data['label'];
      placeholder = data['placeholder'];
      initialValue = data['value'];

      if (initialValue != null) {
        widget.onChanged(field, initialValue);
      }

      if (type == InputType.password) {
        obscureText = true;
      } else if (type == InputType.textarea) {
        minLines = 2;
        maxLines = null;
      } else if (type == InputType.number) {
        keyboardType = TextInputType.number;
      }
    });
  }

  /// 根据type转换数据类型
  dynamic _transformValue(String? value) {
    dynamic val = value;
    if (type == InputType.number) {
      val = num.tryParse(value ?? '');
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      enabled: !disabled,
      validator: (value) {
        dynamic val = _transformValue(value);
        return validator(label, val, rules);
      },
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControlLabel(data: widget.data, required: required),
            BaseTextField(
              state: state,
              obscureText: obscureText,
              keyboardType: keyboardType,
              minLines: minLines,
              maxLines: maxLines,
              readonly: readonly,
              placeholder: placeholder,
              formatValue: (FormFieldState state) {
                return state.value;
              },
              onTap: () {
                if (readonly || disabled) return;
              },
              onChanged: (value) {
                widget.onChanged(field, _transformValue(value));
                state.didChange(value);
              },
            ),
          ],
        );
      },
    );
  }
}
