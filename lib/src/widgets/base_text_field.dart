import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model.dart';

class BaseTextField extends StatefulWidget {
  final FormFieldState state;
  final bool? readonly;
  final void Function()? onTap;
  final String? placeholder;
  final String? Function(FormFieldState state)? formatValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const BaseTextField({
    super.key,
    required this.state,
    this.readonly = false,
    this.onTap,
    this.placeholder,
    this.formatValue,
    this.prefixIcon,
    this.suffixIcon,
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
    TextTheme textTheme = Theme.of(context).textTheme;

    final decoration = Provider.of<JsonGenFormModel>(context).decoration;
    InputDecoration inputDecoration =
        decoration?.inputDecoration ?? const InputDecoration();

    return TextField(
      controller: _controller,
      enabled: widget.state.widget.enabled,
      readOnly: widget.readonly!,
      style: textTheme.bodySmall,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      decoration: inputDecoration.copyWith(
        hintText: widget.placeholder,
        suffixIcon: widget.suffixIcon,
        errorText: widget.state.errorText,
      ),
    );
  }
}
