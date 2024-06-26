import 'package:flutter/material.dart';

double groupSpace = 10;
double fieldSpace = 10;

TextStyle groupLabelStyle = const TextStyle(
  height: 1.5,
  fontSize: 14,
  color: Colors.white,
);
TextStyle labelStyle = const TextStyle(
  height: 1.5,
  fontSize: 12,
  color: Colors.white,
);
TextStyle fieldStyle = const TextStyle(
  height: 1.2,
  fontSize: 10,
  color: Colors.white,
);
TextStyle hintStyle = fieldStyle.copyWith(color: Colors.grey);
TextStyle errorStyle = const TextStyle(
  height: 1.3,
  fontSize: 12,
  color: Color(0xffffb4ab),
);

Color primaryColor = Colors.blue;
Color errorColor = Colors.red;
Color disabledColor = Colors.grey;

OutlineInputBorder _inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    color: Colors.transparent,
    width: 1,
  ),
);
InputDecoration defaultInputDecoration = InputDecoration(
  // 背景色灰色
  filled: true,
  fillColor: const Color(0xff0F1719).withOpacity(0.5),
  // 提示文案样式
  hintStyle: hintStyle,
  // 边框
  border: _inputBorder,
  enabledBorder: _inputBorder,
  disabledBorder: _inputBorder,
  focusedBorder: _inputBorder.copyWith(
    borderSide: BorderSide(color: primaryColor),
  ),
  errorBorder: _inputBorder.copyWith(
    borderSide: BorderSide(color: errorColor),
  ),
);
