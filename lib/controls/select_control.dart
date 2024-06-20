import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../constants.dart';

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

class _SelectControlState extends State<SelectControl> {
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

  void _initData() {
    setState(() {
      final data = widget.data;

      rules = data['rules'];
      options = data['options'] ?? [];
      required = rules?.any((item) => item['required'] == true) ?? false;

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;
      multiple = data['multiple'] == true;

      field = data['field'];
      label = data['label'];
      placeholder = data['placeholder'];
      initialValue = data['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<SinglePickerData> singlePickerData = options!
        .map((item) => SinglePickerData(
              label: item['label'],
              value: item['value'],
            ))
        .toList();

    return FormField(
      initialValue: initialValue,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(label: label, required: required),
            GestureDetector(
              onTap: () {
                showSinglePicker(
                  context,
                  title: label,
                  data: singlePickerData,
                  value: state.value,
                ).then((selected) {
                  if (selected != null) {
                    state.didChange(selected.value);
                    widget.onChanged(field, selected.value);
                  }
                });
              },
              child: InnerInput(state: state, child: _select(state)),
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

  Widget _select(FormFieldState state) {
    dynamic value = state.value;
    String label = '';
    if (value != null) {
      label = options!.firstWhere((item) => item['value'] == value)['label'];
    } else if (placeholder != null) {
      label = placeholder!;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: value != null ? fieldStyle : hintStyle,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_drop_down, color: Colors.grey),
      ],
    );
  }
}
