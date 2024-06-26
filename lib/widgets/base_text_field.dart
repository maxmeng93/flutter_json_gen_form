import 'package:flutter/material.dart';
import '../constants.dart';

class BaseTextField extends StatefulWidget {
  final FormFieldState state;
  final bool? readonly;
  final void Function()? onTap;
  final String? placeholder;
  final String? Function(FormFieldState state)? formatValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputDecoration? inputDecoration;

  const BaseTextField({
    super.key,
    required this.state,
    this.readonly = false,
    this.onTap,
    this.placeholder,
    this.formatValue,
    this.prefixIcon,
    this.suffixIcon,
    this.inputDecoration,
  });

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setValue();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BaseTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.value != null) {
      _setValue();
    }
  }

  void _setValue() {
    final state = widget.state;
    if (state.value == null) {
      _controller.text = '';
    } else {
      if (widget.formatValue != null) {
        _controller.text = widget.formatValue!(state) ?? '';
      } else {
        _controller.text = state.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.state.widget.enabled,
      readOnly: widget.readonly!,
      style: fieldStyle,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      decoration: defaultInputDecoration.copyWith(
        hintText: widget.placeholder,
        suffixIcon: widget.suffixIcon,
        errorText: widget.state.errorText,
      ),
    );
  }
}
