import 'package:flutter/material.dart';

class JsonGenFormTheme {
  static ThemeData getTheme(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);
    final isDark = baseTheme.brightness == Brightness.dark;
    final ColorScheme colorScheme = baseTheme.colorScheme;
    final Color primaryColor = colorScheme.primary;
    final Color errorColor = colorScheme.error;

    return baseTheme.copyWith(
      textTheme: const TextTheme(
        /// field body style
        bodySmall: TextStyle(
          height: 1.2,
          fontSize: 10,
          color: Colors.white,
        ),

        /// group label
        labelMedium: TextStyle(
          height: 1.5,
          fontSize: 14,
          color: Colors.white,
        ),

        /// field label
        labelSmall: TextStyle(
          height: 1.5,
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? const Color(0xff0F1719).withOpacity(0.5)
            : const Color(0xfff5f5f5),
        // 提示文案样式
        hintStyle: const TextStyle(
          height: 1.2,
          fontSize: 10,
          color: Colors.grey,
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

  static final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  );
}
