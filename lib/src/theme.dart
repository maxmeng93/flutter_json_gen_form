import 'package:flutter/material.dart';

class JsonGenFormTheme {
  static ThemeData getTheme(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);
    final ColorScheme colorScheme = baseTheme.colorScheme;
    final Color primaryColor = colorScheme.primary;
    final Color errorColor = colorScheme.error;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 1,
      ),
    );

    return baseTheme.copyWith(
      textTheme: TextTheme(
        /// field body style
        bodySmall: TextStyle(
          height: 1.2,
          fontSize: 10,
          color: colorScheme.onSurface,
        ),

        /// group label
        labelMedium: TextStyle(
          height: 1.5,
          fontSize: 14,
          color: colorScheme.onSurface,
        ),

        /// field label
        labelSmall: TextStyle(
          height: 1.5,
          fontSize: 12,
          color: colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        iconColor: colorScheme.inverseSurface,
        // 提示文案样式
        hintStyle: TextStyle(
          height: 1.2,
          fontSize: 10,
          color: colorScheme.onSurface.withOpacity(0.5),
        ),
        errorStyle: TextStyle(
          height: 1.3,
          fontSize: 12,
          color: errorColor,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: primaryColor),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: errorColor),
        ),
      ),
    );
  }
}
