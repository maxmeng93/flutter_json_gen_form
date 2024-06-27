import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final dynamic data;
  final bool required;

  const FieldLabel({
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

    bool isGroup = data['type'] == 'group';
    TextTheme theme = Theme.of(context).textTheme;
    TextStyle? style = isGroup ? theme.labelMedium : theme.labelSmall;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: style!),
        const SizedBox(width: 3),
        Visibility(
          visible: required,
          child: const Text('*', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
