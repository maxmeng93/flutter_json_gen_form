import 'package:flutter/material.dart';

class InnerWrap extends StatelessWidget {
  final FormFieldState state;
  final Widget child;

  const InnerWrap({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }
}
