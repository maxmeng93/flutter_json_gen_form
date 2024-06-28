import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model.dart';

class ControlLabel extends StatelessWidget {
  final dynamic data;
  final bool required;

  const ControlLabel({
    super.key,
    this.data,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    String label = data['label'] ?? '';
    bool hiddenLabel = data['hiddenLabel'] ?? false;
    if (hiddenLabel || label == '') {
      return const SizedBox.shrink();
    }

    final decoration = Provider.of<JsonGenFormModel>(context).decoration;
    final controlLabelWrap = decoration?.controlLabelWrap;

    TextTheme theme = Theme.of(context).textTheme;
    TextStyle? style = decoration?.controlLabelStyle ?? theme.labelSmall;

    Widget child = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: style),
        const SizedBox(width: 3),
        Visibility(
          visible: required,
          child: const Text('*', style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    if (controlLabelWrap != null) {
      return controlLabelWrap(child, data);
    }
    return child;
  }
}
