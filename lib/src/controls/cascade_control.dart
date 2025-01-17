import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';
import './abstract.dart' show ControlInterface;

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

class _CascadeControlState extends State<CascadeControl>
    implements ControlInterface {
  final GlobalKey _key = GlobalKey<FormFieldState>();
  late String field;
  String? label;
  String? placeholder;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;
  List<dynamic>? rules;
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

      field = getField(data);
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
    ThemeData theme = Theme.of(context);

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
              formatValue: (FormFieldState state) {
                dynamic value = state.value;
                if (value == null) return null;
                return _getLabels(value, options!).join(' / ');
              },
              onTap: () {
                if (readonly || disabled) return;

                showCascadePicker(
                  context,
                  options: _getOptions(options),
                  value: state.value,
                ).then((value) {
                  widget.onChanged(field, value);
                  state.didChange(value);
                });
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
