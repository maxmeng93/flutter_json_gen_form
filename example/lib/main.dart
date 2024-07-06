import 'package:flutter/material.dart';
import 'package:json_gen_form/json_gen_form.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey _key = GlobalKey<JsonGenFormState>();
  final List<dynamic> _data = [
    {
      "type": "group",
      "label": "分组1",
      "field": "group1",
      "children": [
        {
          "type": "row",
          "gutter": 10,
          "children": [
            {
              "type": "col",
              "child": {"type": "text", "field": "name", "label": "组名1"}
            },
            {
              "type": "col",
              "child": {"type": "number", "field": "num", "label": "人数"}
            }
          ]
        },
        {"type": "text", "field": "manage", "label": "管理员"}
      ]
    },
    {
      "type": "text",
      "field": "name",
      "label": "姓名",
      "value": "隔壁老王",
      "readonly": true,
      "placeholder": "请输入姓名",
      "rules": [
        {"required": true, "message": "请输入姓名"}
      ]
    },
    {
      "type": "password",
      "field": "password",
      "label": "密码",
      "value": null,
      "placeholder": "请输入密码",
      "rules": [
        {"required": true, "message": "请输入密码"},
        {
          "pattern": "^[a-zA-Z0-9_-]{6,16}\$",
          "message": "密码必须为6-16位字母、数字、下划线、减号"
        }
      ]
    },
    {
      "type": "textarea",
      "field": "remark",
      "label": "自我介绍",
      "value": null,
      "placeholder": "请简单介绍一下你自己",
      "rules": []
    },
    {
      "type": "number",
      "field": "age",
      "label": "年龄",
      "value": null,
      "placeholder": "请输入年龄",
      "rules": [
        {"required": true, "message": "请输入年龄"},
        {"min": 18, "message": "年龄必须大于18岁"}
      ]
    },
    {
      "type": "select",
      "field": "province",
      "label": "省份",
      "value": 1,
      "placeholder": "请选择省份",
      "options": [
        {"label": "山西", "value": 1},
        {"label": "陕西", "value": 2},
        {"label": "山东", "value": 3}
      ]
    },
    {
      "type": "cascade",
      "field": "city",
      "label": "城市",
      "value": null,
      "placeholder": "请选择城市",
      "options": [
        {
          "label": "山西",
          "value": 1,
          "children": [
            {
              "label": "太原",
              "value": 11,
              "children": [
                {"label": "小店区", "value": 111},
                {"label": "迎泽区", "value": 112}
              ]
            },
            {"label": "吕梁", "value": 12},
            {"label": "大同", "value": 13}
          ]
        },
        {
          "label": "陕西",
          "value": 2,
          "children": [
            {"label": "西安", "value": 21},
            {"label": "咸阳", "value": 22}
          ]
        }
      ]
    },
    {
      "type": "date",
      "field": "birthday",
      "label": "生日",
      "value": null,
      "placeholder": "请选择生日"
    },
    {
      "type": "radio",
      "field": "sex",
      "label": "性别",
      "value": null,
      "options": [
        {"label": "男", "value": 1},
        {"label": "女", "value": 2},
        {"label": "保密", "value": 0}
      ]
    },
    {
      "type": "checkbox",
      "field": "hobby",
      "label": "爱好",
      "value": [],
      // "direction": "vertical",
      "options": [
        {"label": "篮球", "value": "basketball"},
        {"label": "足球", "value": "football"},
        {"label": "羽毛球", "value": "badminton"}
      ],
      "rules": [
        {"required": true, "message": "请选择爱好"}
      ]
    },
    {
      "type": "switch",
      "field": "agree",
      "label": "同意协议",
      "value": null,
      "rules": [
        {"required": true, "message": "请同意协议"}
      ]
    },
    {
      "type": "media",
      "field": "media",
      "label": "上传照片视频",
      "value": null,
      "rules": null,
      "multiple": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        // brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
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
                  decoration: JsonGenFormDecoration(
                    // groupLabelWrap: (Widget child, dynamic data) {
                    //   return Container(
                    //     margin: const EdgeInsets.only(bottom: 5),
                    //     child: child,
                    //   );
                    // },
                    controlLabelWrap: (Widget child, dynamic data) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: child,
                      );
                    },
                    controlWrap: (Widget child, dynamic data) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: child,
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final formState = _key.currentState as JsonGenFormState;
                    try {
                      final data = await formState.validate();
                      debugPrint('提交成功 $data');
                    } catch (e) {
                      debugPrint('Validation error: $e');
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
