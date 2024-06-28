import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';

class RadioControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const RadioControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<RadioControl> createState() => _RadioControlState();
}

class _RadioControlState extends State<RadioControl> {
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

  /// 是否垂直排列
  bool isVertical = false;

  /// item 水平间距
  double itemHorizontalSpace = 0;

  /// item 垂直间距
  double itemVerticalSpace = 0;

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

      field = getField(data);
      label = data['label'];
      initialValue = data['value'];

      isVertical = data['direction'] == 'vertical';
      direction = isVertical ? Axis.vertical : Axis.horizontal;
      itemHorizontalSpace = data['itemHorizontalSpace'] ?? 16;
      itemVerticalSpace = data['itemVerticalSpace'] ?? 8;

      if (initialValue != null) {
        widget.onChanged(field, initialValue);
      }
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
            ControlLabel(data: widget.data, required: required),
            InnerWrap(
              state: state,
              child: Wrap(
                spacing: isVertical ? itemVerticalSpace : itemHorizontalSpace,
                runSpacing: itemVerticalSpace,
                direction: direction,
                children: options!.map((item) {
                  return _item(context, item['label'], item['value'], state);
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

  Widget _item(
    BuildContext context,
    String? label,
    dynamic val,
    FormFieldState state,
  ) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final value = state.value;
    bool isCheck = value != null && val == value;

    return GestureDetector(
      onTap: () {
        if (readonly || disabled) return;
        state.didChange(val);
        widget.onChanged(field, val);
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Visibility(
              visible: isCheck,
              child: Center(
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),
          ),
          if (label != null) Text(label, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}