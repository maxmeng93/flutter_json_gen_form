String getField(dynamic data) {
  String curField = data['field'] ?? '';
  String upField = data['upField'] ?? '';

  List<String> list = [upField, curField];
  list = list.where((item) => item != '').toList();
  return list.join('.');
}
