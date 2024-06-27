/// 控件类型枚举
enum ControlType {
  group,
  row,
  col,
}

/// 根据字符串类型获取控件类型枚举值
ControlType? getControlType(String type) {
  return ControlType.values.firstWhere((item) => item.name == type);
}

/// 获取完整字段
String getField(dynamic data) {
  String curField = data['field'] ?? '';
  String upField = data['upField'] ?? '';

  List<String> list = [upField, curField];
  list = list.where((item) => item != '').toList();
  return list.join('.');
}
