import 'package:flutter/material.dart';
import '../widgets/field_label.dart';
import '../validator/validator.dart';
import '../constants.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff0F1719).withOpacity(0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: fieldStyle,
              decoration: null,
            ),
          ),
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(left: 6),
            child: Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
