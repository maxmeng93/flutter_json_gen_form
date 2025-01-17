import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';
import './abstract.dart' show ControlInterface;

class SwitchControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const SwitchControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<SwitchControl> createState() => _SwitchControlState();
}

class _SwitchControlState extends State<SwitchControl>
    implements ControlInterface {
  final GlobalKey _key = GlobalKey<FormFieldState>();
  late String field;
  String? label;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;

  /// 规则
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

      rules = data['rules'];
      required = rules?.any((item) => item['required'] == true) ?? false;

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;

      field = getField(data);
      label = data['label'];
      initialValue = data['value'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _key,
      initialValue: initialValue,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControlLabel(data: widget.data, required: required),
            InnerWrap(state: state, child: _switch(context, state)),
            HelperError(state: state),
          ],
        );
      },
      validator: (value) {
        return validator(label, value, rules);
      },
    );
  }

  Widget _switch(BuildContext context, FormFieldState state) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color surfaceContainer = colorScheme.surfaceContainer;
    Color primaryColor = colorScheme.primary;
    bool isCheck = state.value;

    return GestureDetector(
      onTap: () {
        if (readonly || disabled) return;
        state.didChange(!isCheck);
        widget.onChanged(field, !isCheck);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              width: 32,
              height: 16,
              decoration: BoxDecoration(
                color: isCheck ? primaryColor : surfaceContainer,
                border: Border.all(
                  color: isCheck ? primaryColor : surfaceContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: isCheck ? null : 0,
              right: isCheck ? 0 : null,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
