import 'package:flutter/material.dart';
import '../constants.dart';

class InnerInput extends StatelessWidget {
  final FormFieldState state;
  final String? placeholder;
  final String? Function(FormFieldState state)? formatValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const InnerInput({
    super.key,
    required this.state,
    this.placeholder,
    this.formatValue,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final value = formatValue != null ? formatValue!(state) : state.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff0F1719).withOpacity(0.5),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            _iconWrap(prefixIcon!),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              value ?? placeholder ?? '',
              style: value != null ? fieldStyle : hintStyle,
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 4),
            _iconWrap(suffixIcon!),
          ],
        ],
      ),
    );
  }

  Widget _iconWrap(Widget icon) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(child: icon),
    );
  }
}
