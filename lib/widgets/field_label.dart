import 'package:flutter/material.dart';
import '../constants.dart';

class FieldLabel extends StatelessWidget {
  final String? label;
  final bool hiddenLabel;
  final bool required;

  const FieldLabel({
    super.key,
    this.label,
    this.hiddenLabel = false,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hiddenLabel || label == null || label == '') {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label!, style: labelStyle),
        const SizedBox(width: 3),
        Visibility(
          visible: required,
          child: const Text('*', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
