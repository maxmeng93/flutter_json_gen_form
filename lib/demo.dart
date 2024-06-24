import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './json_gen_form.dart';
// import '/api/oss.dart';

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

  // Future<String> _uploadFile(String filePath, String field) async {
  //   final extension = filePath.split('.').last;
  //   final data = await MultipartFile.fromFile(filePath);

  //   try {
  //     var res = await uploadFiles({
  //       'upload_file': data,
  //     }, {
  //       'file_extension': '.$extension',
  //       // TODO: oss 图片分类
  //       'category': 'mapscan.iot.imp',
  //     });
  //     String url = res.data['data']['url'];

  //     return Future.value(url);
  //   } catch (e) {
  //     debugPrint('上传文件失败');
  //     return Future.value('');
  //   }
  // }

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
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff222124),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                JsonGenForm(
                  key: _key,
                  config: _data,
                  // uploadFile: _uploadFile,
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
      ),
    );
  }
}
