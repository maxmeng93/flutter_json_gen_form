import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../constants.dart';

class CheckboxControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const CheckboxControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<CheckboxControl> createState() => _CheckboxControlState();
}

class _CheckboxControlState extends State<CheckboxControl> {
  late String field;
  String? label;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;

  /// 规则
  List<dynamic>? rules;

  /// 选项
  List<dynamic>? options;

  /// item 排列方向
  Axis direction = Axis.horizontal;

  /// item 间距
  double itemSpace = 16;

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
      initialValue = data['value'] ?? [];
    });
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
            InnerWrap(
              state: state,
              child: Row(
                children: options!.map((item) {
                  return _item(item['label'], item['value'], state);
                }).toList(),
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

  Widget _item(String? label, dynamic val, FormFieldState state) {
    final value = state.value ?? [];
    bool isCheck = value.contains(val);

    return Container(
      margin: EdgeInsets.only(
        right: direction == Axis.horizontal ? itemSpace : 0,
        bottom: direction == Axis.vertical ? itemSpace : 0,
      ),
      child: GestureDetector(
        onTap: () {
          if (readonly || disabled) return;

          if (isCheck) {
            value.remove(val);
          } else {
            value.add(val);
          }
          state.didChange(value);
          widget.onChanged(field, value);
        },
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Visibility(
                visible: isCheck,
                child: Center(
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
            if (label != null) Text(label, style: fieldStyle),
          ],
        ),
      ),
    );
  }
}
