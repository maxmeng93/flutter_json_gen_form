# 表单生成

## 通用参数

除 `group` 外，其他类型都有以下通用参数

| 字段       | 描述  | 类型      | 默认值   | 必填   |
|----------|-----|---------|-------|------|
| type     | 类型  | String  | ''    | true |
| field    | 字段名 | String  | ''    | true |
| label    | 标签  | String  | -     | -  |
| hiddenLabel | 隐藏标签 | bool    | false | - |
| value    | 默认值 | dynamic | -     | -  |
| disabled | 是否禁用 | bool    | false | -  |
| readonly | 是否只读 | bool    | false | -  |
| rules    | 校验规则 | List    | []    | -  |

## 表单类型

### group 分组

| 字段          | 描述   | 类型        | 默认值     | 必填   |
|-------------|------|-----------|---------|------|
| type        | 类型   | String    | 'group' | true |
| field       | 字段名  | String    | ''      | -    |
| label       | 标签   | String    | ''      | -    |
| hiddenLabel | 隐藏标签 | bool      | ''      | -    |
| children    | 子表单  | List<Map> | []      | -    |

### text 文本框
| 字段   | 描述 | 类型     | 默认值    | 必填   |
|------|----|--------|--------|------|
| type | 类型 | String | 'text' | true |
| placeholder | 提示 | String  | -     | -  |
| 通用参数 | -  | -      | -      | -    |

### password 密码框
| 字段   | 描述 | 类型     | 默认值    | 必填   |
|------|----|--------|--------|------|
| type | 类型 | String | 'password' | true |
| placeholder | 提示 | String  | -     | -  |
| 通用参数 | -  | -      | -      | -    |

### textArea 多行文本框
| 字段   | 描述 | 类型     | 默认值    | 必填   |
|------|----|--------|--------|------|
| type | 类型 | String | 'textArea' | true |
| placeholder | 提示 | String  | -     | -  |
| 通用参数 | -  | -      | -      | -    |

### number 数字
| 字段   | 描述 | 类型     | 默认值    | 必填   |
|------|----|--------|--------|------|
| type | 类型 | String | 'number' | true |
| placeholder | 提示 | String  | -     | -  |
| 通用参数 | -  | -      | -      | -    |

### radio 单选框
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'radio' | true |
| options | 选项 | List<Map> | []      | -  |
| 通用参数    | -  | -         | -       | -    |

### checkbox 复选框
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'checkbox' | true |
| options | 选项 | List<Map> | []      | -  |
| 通用参数    | -  | -         | -       | -    |

### select 下拉框
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'select' | true |
| options | 选项 | List<Map> | []      | -  |
| multiple | 是否多选 | bool      | false   | -  |
| 通用参数    | -  | -         | -       | -    |

### switch 开关
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'switch' | true |
| 通用参数    | -  | -         | -       | -    |

### media 多媒体上传
| 字段        | 描述                 | 类型     | 默认值     | 必填   |
|-----------|--------------------|--------|---------|------|
| type      | 类型                 | String | 'media' | true |
| mediaType | 媒体类型(media、image、video) | String | 'media' | -    |
| multiple  | 是否多选               | bool   | false   | -    |
| 通用参数      | -                  | -      | -       | -    |

#### ios配置 info.plist
```
<key>NSCameraUsageDescription</key>
<string>需要摄像头拍照或扫码</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要从图库选择照片或视频</string>
<key>NSMicrophoneUsageDescription</key>
<string>录制视频需要访问麦克风</string>
```

#### android配置 AndroidManifest.xml
```
<uses-permission android:name="android.permission.CAMERA" />
```

### date 日期选择
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'date' | true |
|         |    |           |        |      |


### time 时间选择
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'time' | true |
|         |    |           |        |      |

### datetime 日期时间选择
| 字段      | 描述 | 类型        | 默认值     | 必填   |
|---------|----|-----------|---------|------|
| type    | 类型 | String    | 'datetime' | true |
|         |    |           |            |      |

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

## 依赖项
- image_picker
- fijkplayer
