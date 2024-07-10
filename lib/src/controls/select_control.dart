import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';
import './abstract.dart' show ControlInterface;

class SelectControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const SelectControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<SelectControl> createState() => _SelectControlState();
}

class _SelectControlState extends State<SelectControl>
    implements ControlInterface {
  final GlobalKey _key = GlobalKey<FormFieldState>();
  late String field;
  String? label;
  String? placeholder;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;
  bool multiple = false;

  /// 规则
  List<dynamic>? rules;

  /// 选项
  List<dynamic>? options;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void setValue(dynamic value) {
    final state = _key.currentState as FormFieldState;
    state.didChange(value);
  }

  void _initData() {
    setState(() {
      final data = widget.data;

      rules = data['rules'];
      options = data['options'] ?? [];
      required = rules?.any((item) => item['required'] == true) ?? false;

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;
      multiple = data['multiple'] == true;

      field = getField(data);
      label = data['label'];
      placeholder = data['placeholder'];
      initialValue = data['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<SinglePickerData> singlePickerData = options!
        .map((item) => SinglePickerData(
              label: item['label'],
              value: item['value'],
            ))
        .toList();

    return FormField(
      key: _key,
      initialValue: initialValue,
      enabled: !disabled,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControlLabel(data: widget.data, required: required),
            BaseTextField(
              state: state,
              readonly: true,
              placeholder: placeholder,
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: theme.inputDecorationTheme.iconColor,
              ),
              onTap: () {
                if (readonly || disabled) return;
                showSinglePicker(
                  context,
                  title: label,
                  options: singlePickerData,
                  value: state.value,
                  multiple: multiple,
                ).then((selected) {
                  if (selected != null) {
                    if (multiple) {
                      state.didChange(selected ?? []);
                      widget.onChanged(field, selected ?? []);
                    } else {
                      state.didChange(selected);
                      widget.onChanged(field, selected);
                    }
                  }
                });
              },
              formatValue: (FormFieldState state) {
                dynamic value = state.value;
                if (value == null) return null;

                if (multiple) {
                  List<dynamic> selected = value;
                  return selected.map((item) {
                    return options!.firstWhere(
                        (option) => option['value'] == item)['label'];
                  }).join(', ');
                } else {
                  return options!
                      .firstWhere((item) => item['value'] == value)['label'];
                }
              },
            ),
          ],
        );
      },
      validator: (value) {
        return validator(label, value, rules);
      },
    );
  }
}
