import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';

class CascadeControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const CascadeControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<CascadeControl> createState() => _CascadeControlState();
}

class _CascadeControlState extends State<CascadeControl> {
  late String field;
  String? label;
  String? placeholder;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;

  /// 规则
  List<dynamic>? rules;

  /// 选项
  List<dynamic>? options;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    setState(() {
      final data = widget.data;

      rules = data['rules'];
      options = data['options'] ?? [];
      required = rules?.any((item) => item['required'] == true) ?? false;

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;

      field = data['field'];
      label = data['label'];
      placeholder = data['placeholder'];
      initialValue = data['value'];
    });
  }

  List<CascadePickerData> _getOptions(dynamic data) {
    if (data.length == 0) return [];

    List<CascadePickerData> options = [];

    for (var item in data) {
      options.add(CascadePickerData(
        label: item['label'],
        value: item['value'],
        children:
            item['children'] != null ? _getOptions(item['children']) : null,
      ));
    }

    return options;
  }

  List<String> _getLabels(List<dynamic> values, List<dynamic> data) {
    if (values.isEmpty) return [];

    var value = values[0];
    var item = data.firstWhere((item) => item['value'] == value);
    if (values.length == 1) return [item['label']];

    return item['children'] != null
        ? [item['label'], ..._getLabels(values.sublist(1), item['children'])]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(label: label, required: required),
            GestureDetector(
              onTap: () {
                showCascadePicker(
                  context,
                  options: _getOptions(options),
                  value: state.value,
                ).then((value) {
                  widget.onChanged(field, value);
                  state.didChange(value);
                });
              },
              child: InnerInput(
                state: state,
                placeholder: placeholder,
                suffixIcon:
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                formatValue: (FormFieldState state) {
                  dynamic value = state.value;
                  if (value == null) return null;
                  return _getLabels(value, options!).join(' / ');
                },
              ),
            ),
            HelperError(state: state),
          ],
        );
      },
      validator: (value) {
        return validator(label, value, rules);
      },
    );
  }
}
