<div align="center">
<h1>JSON_GEN_FORM</h1>
<p>使用json来生成flutter表单，内置多种表单控件，<br/>支持验证、自定义布局、自定义样式、表单无限分组嵌套等</p>

[English](./README.md) · 中文

![](./screenshots/json_gen_form.gif)

</div>

## 功能

- 使用 json 渲染表单
- 表单验证
- 自定义表单样式
- 自定义布局（row, col）
- 表单无限分组嵌套（group）
- 通过方法修改整个表单值或单个表单控件值
- 表单控件
  - 文本框
  - 密码框
  - 多行文本框
  - 数字
  - 单选框
  - 复选框
  - 下拉框
  - 开关
  - 多媒体上传
  - 日期选择
  - 时间选择
  - 日期时间选择

## 使用

```dart
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
      "type": "text",
      "field": "name",
      "label": "姓名",
      "value": "隔壁老王",
      "placeholder": "请输入姓名",
      "rules": [
        {"required": true, "message": "请输入姓名"}
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
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
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
                      debugPrint('表单验证成功: $data');
                    } catch (e) {
                      debugPrint('表单验证失败: $e');
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
```

## 通用参数

除 `group`、`row`、`col` 外，其他类型都有以下通用参数。所有类型都有 `extra`。

| 字段        | 描述     | 类型    | 默认值 | 必填 |
| ----------- | -------- | ------- | ------ | ---- |
| type        | 类型     | String  | ''     | true |
| field       | 字段名   | String  | ''     | true |
| label       | 标签     | String  | -      | -    |
| hiddenLabel | 隐藏标签 | bool    | false  | -    |
| value       | 默认值   | dynamic | -      | -    |
| disabled    | 是否禁用 | bool    | false  | -    |
| readonly    | 是否只读 | bool    | false  | -    |
| rules       | 校验规则 | List    | []     | -    |
| extra       | 额外参数 | dynamic |        | -    |

## 表单类型

### group 分组

| 字段        | 描述     | 类型      | 默认值  | 必填 |
| ----------- | -------- | --------- | ------- | ---- |
| type        | 类型     | String    | 'group' | true |
| field       | 字段名   | String    | ''      | -    |
| label       | 标签     | String    | ''      | -    |
| hiddenLabel | 隐藏标签 | bool      | ''      | -    |
| children    | 子表单   | List<Map> | []      | -    |

### text 文本框

| 字段        | 描述 | 类型   | 默认值 | 必填 |
| ----------- | ---- | ------ | ------ | ---- |
| type        | 类型 | String | 'text' | true |
| placeholder | 提示 | String | -      | -    |
| 通用参数    | -    | -      | -      | -    |

### password 密码框

| 字段        | 描述 | 类型   | 默认值     | 必填 |
| ----------- | ---- | ------ | ---------- | ---- |
| type        | 类型 | String | 'password' | true |
| placeholder | 提示 | String | -          | -    |
| 通用参数    | -    | -      | -          | -    |

### textarea 多行文本框

| 字段        | 描述 | 类型   | 默认值     | 必填 |
| ----------- | ---- | ------ | ---------- | ---- |
| type        | 类型 | String | 'textarea' | true |
| placeholder | 提示 | String | -          | -    |
| 通用参数    | -    | -      | -          | -    |

### number 数字

| 字段        | 描述 | 类型   | 默认值   | 必填 |
| ----------- | ---- | ------ | -------- | ---- |
| type        | 类型 | String | 'number' | true |
| placeholder | 提示 | String | -        | -    |
| 通用参数    | -    | -      | -        | -    |

### radio 单选框

| 字段                | 描述         | 类型      | 默认值       | 必填 |
| ------------------- | ------------ | --------- | ------------ | ---- |
| type                | 类型         | String    | 'radio'      | true |
| options             | 选项         | List<Map> | []           | -    |
| direction           | 选项排列方向 | String    | 'horizontal' | -    |
| itemHorizontalSpace | 选项水平间距 | double    | 16           | -    |
| itemVerticalSpace   | 选项垂直间距 | double    | 8            | -    |
| 通用参数            | -            | -         | -            | -    |

### checkbox 复选框

| 字段                | 描述         | 类型      | 默认值       | 必填 |
| ------------------- | ------------ | --------- | ------------ | ---- |
| type                | 类型         | String    | 'checkbox'   | true |
| options             | 选项         | List<Map> | []           | -    |
| direction           | 选项排列方向 | String    | 'horizontal' | -    |
| itemHorizontalSpace | 选项水平间距 | double    | 16           | -    |
| itemVerticalSpace   | 选项垂直间距 | double    | 8            | -    |
| 通用参数            | -            | -         | -            | -    |

### select 下拉框

| 字段     | 描述     | 类型      | 默认值   | 必填 |
| -------- | -------- | --------- | -------- | ---- |
| type     | 类型     | String    | 'select' | true |
| options  | 选项     | List<Map> | []       | -    |
| multiple | 是否多选 | bool      | false    | -    |
| 通用参数 | -        | -         | -        | -    |

### switch 开关

| 字段     | 描述 | 类型   | 默认值   | 必填 |
| -------- | ---- | ------ | -------- | ---- |
| type     | 类型 | String | 'switch' | true |
| 通用参数 | -    | -      | -        | -    |

### media 多媒体上传

| 字段      | 描述                          | 类型   | 默认值  | 必填 |
| --------- | ----------------------------- | ------ | ------- | ---- |
| type      | 类型                          | String | 'media' | true |
| mediaType | 媒体类型(media、image、video) | String | 'media' | -    |
| multiple  | 是否多选                      | bool   | false   | -    |
| 通用参数  | -                             | -      | -       | -    |

#### ios 配置 info.plist

```
<key>NSCameraUsageDescription</key>
<string>需要摄像头拍照或扫码</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要从图库选择照片或视频</string>
<key>NSMicrophoneUsageDescription</key>
<string>录制视频需要访问麦克风</string>
```

#### android 配置 AndroidManifest.xml

```
<uses-permission android:name="android.permission.CAMERA" />
```

### date 日期选择

| 字段 | 描述 | 类型   | 默认值 | 必填 |
| ---- | ---- | ------ | ------ | ---- |
| type | 类型 | String | 'date' | true |

### time 时间选择

| 字段 | 描述 | 类型   | 默认值 | 必填 |
| ---- | ---- | ------ | ------ | ---- |
| type | 类型 | String | 'time' | true |

### datetime 日期时间选择

| 字段 | 描述 | 类型   | 默认值     | 必填 |
| ---- | ---- | ------ | ---------- | ---- |
| type | 类型 | String | 'datetime' | true |

## 布局类型

### row 行

`row` 的 `children` 的 `type` 必须为 `col`。

| 字段     | 描述       | 类型   | 默认值 | 必填 |
| -------- | ---------- | ------ | ------ | ---- |
| type     | 类型       | String | 'row'  | true |
| gutter   | 子元素间距 | double | 0      | -    |
| children | 子元素列表 | List   | []     | -    |

### col 列

`col` 的父元素必须为 `row`。

| 字段  | 描述       | 类型   | 默认值 | 必填 |
| ----- | ---------- | ------ | ------ | ---- |
| type  | 类型       | String | 'col'  | true |
| flex  | 空间大小   | int    | 1      | -    |
| child | 子元素配置 | Map    |        |      |

### group 分组

| 字段  | 描述   | 类型   | 默认值  | 必填 |
| ----- | ------ | ------ | ------- | ---- |
| type  | 类型   | String | 'group' | true |
| field | 字段名 | String | null    | -    |

## 验证规则

- required 必填
- type 快捷校验类型，仅支持文本输入框
  - email 邮箱
  - url 网址
- min string 类型时为字符串长度；number 类型时为确定数字； array 类型时为数组长度
- max string 类型时为字符串长度；number 类型时为确定数字； array 类型时为数组长度
- len string 类型时为字符串长度；number 类型时为确定数字； array 类型时为数组长度
- pattern 正则校验
- message 错误提示信息
