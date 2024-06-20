import 'package:flutter/material.dart';

class InnerWrap extends StatelessWidget {
  final FormFieldState state;
  final Widget child;

  const InnerWrap({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      // padding: const EdgeInsets.all(12),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8),
      //   color: const Color(0xff0F1719).withOpacity(0.5),
      // ),
      child: child,
    );
  }
}
