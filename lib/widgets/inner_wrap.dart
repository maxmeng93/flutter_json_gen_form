import 'package:flutter/material.dart';

class InnerWrap extends StatelessWidget {
  final FormFieldState state;
  final Widget child;

  const InnerWrap({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: child,
    );
  }
}
