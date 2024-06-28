import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model.dart';

class GroupLabel extends StatelessWidget {
  final dynamic data;
  final bool required;

  const GroupLabel({
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
    final groupLabelWrap = decoration?.groupLabelWrap;

    TextTheme theme = Theme.of(context).textTheme;
    TextStyle? style = decoration?.groupLabelStyle ?? theme.labelMedium;

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

    if (groupLabelWrap != null) {
      return groupLabelWrap(child, data);
    }
    return child;
  }
}
