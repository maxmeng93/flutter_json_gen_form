import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';
import './abstract.dart' show ControlInterface;

class DatetimeControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const DatetimeControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<DatetimeControl> createState() => _DatetimeControlState();
}

Map<String, String> _formatMap = {
  'date': 'yyyy-MM-dd',
  'time': 'HH:mm:ss',
  'datetime': 'yyyy-MM-dd HH:mm:ss',
};

class _DatetimeControlState extends State<DatetimeControl>
    implements ControlInterface {
  final GlobalKey _key = GlobalKey<FormFieldState>();
  late String type;
  late String field;
  String? label;
  String? placeholder;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;
  List<dynamic>? rules;

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

      type = data['type'];
      rules = data['rules'];
      required = rules?.any((item) => item['required'] == true) ?? false;

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;

      field = getField(data);
      label = data['label'];
      placeholder = data['placeholder'];
      initialValue = data['value'];
    });
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
                size: 14,
                Icons.calendar_month_outlined,
                color: theme.inputDecorationTheme.iconColor,
              ),
              onTap: () async {
                if (readonly || disabled) return;

                OmniDateTimePickerType pickerType;
                if (type == 'date') {
                  pickerType = OmniDateTimePickerType.date;
                } else if (type == 'time') {
                  pickerType = OmniDateTimePickerType.time;
                } else {
                  pickerType = OmniDateTimePickerType.dateAndTime;
                }

                DateTime? dateTime = await showOmniDateTimePicker(
                  context: context,
                  type: pickerType,
                  initialDate: state.value != null
                      ? DateTime.parse(state.value.toString())
                      : DateTime.now(),
                  is24HourMode: true,
                  isShowSeconds: true,
                );

                if (dateTime == null) return;
                String formatStr = _formatMap[type] ?? _formatMap['datetime']!;
                String value = DateFormat(formatStr).format(dateTime);
                widget.onChanged(field, value);
                state.didChange(value);
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
