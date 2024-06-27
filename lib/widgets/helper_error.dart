import 'package:flutter/material.dart';

class HelperError extends StatelessWidget {
  final FormFieldState state;
  const HelperError({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (!state.hasError) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8),
      child: Text(
        state.errorText!,
        style: theme.inputDecorationTheme.errorStyle,
      ),
    );
  }
}
