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

  // Future<String> _uploadFile(String filePath) async {
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
          child: JsonGenForm(config: _data),
        ),
      ),
    );
  }
}
