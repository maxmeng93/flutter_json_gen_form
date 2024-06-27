import 'package:flutter/material.dart';
import './demo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        // brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const JsonGenFormPage(),
    );
  }
}
