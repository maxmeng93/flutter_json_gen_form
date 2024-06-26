import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_gen_form/json_gen_form.dart';

class JsonGenFormPage extends StatefulWidget {
  const JsonGenFormPage({super.key});

  @override
  State<JsonGenFormPage> createState() => _JsonGenFormPageState();
}

class _JsonGenFormPageState extends State<JsonGenFormPage> {
  final GlobalKey _key = GlobalKey<JsonGenFormState>();
  final List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String data = await rootBundle.loadString('assets/data/form.json');
    final json = jsonDecode(data);
    setState(() {
      _data.addAll(json.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('json gen form'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              JsonGenForm(
                key: _key,
                config: _data,
              ),
              ElevatedButton(
                onPressed: () {
                  final formState = _key.currentState as JsonGenFormState;
                  final data = formState.validate();
                  if (data == false) {
                    print('验证错误');
                  } else {
                    print('提交成功 $data');
                  }
                },
                child: const Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
