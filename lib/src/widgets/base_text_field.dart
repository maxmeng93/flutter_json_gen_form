import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model.dart';

class BaseTextField extends StatefulWidget {
  final FormFieldState state;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final bool? readonly;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final String? placeholder;
  final String? Function(FormFieldState state)? formatValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const BaseTextField({
    super.key,
    required this.state,
    this.obscureText,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.readonly = false,
    this.onTap,
    this.onChanged,
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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _setValue();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
      focusNode: _focusNode,
      enabled: widget.state.widget.enabled,
      readOnly: widget.readonly!,
      style: textTheme.bodySmall,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapOutside: (PointerDownEvent event) {
        _focusNode.unfocus();
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      decoration: inputDecoration.copyWith(
        hintText: widget.placeholder,
        suffixIcon: widget.suffixIcon,
        errorText: widget.state.errorText,
      ),
    );
  }
}
