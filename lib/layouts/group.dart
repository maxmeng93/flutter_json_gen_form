import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class GroupLayout extends StatelessWidget {
  final dynamic data;
  final Widget Function(Map<String, dynamic> config) buildField;

  const GroupLayout({
    super.key,
    required this.data,
    required this.buildField,
  });

  @override
  Widget build(BuildContext context) {
    String? label = data['label'] ?? '';
    bool hiddenLabel = data['hiddenLabel'] == true;
    List<dynamic> children = data['children'] ?? [];

    return Column(
      children: [
        FieldLabel(label: label, hiddenLabel: hiddenLabel),
        ...children
            .map(
              (item) {
                bool isLast = children.indexOf(item) == children.length - 1;
                return _item(item, isLast);
              },
            )
            .expand((x) => x)
            .toList(),
      ],
    );
  }

  getUpField() {
    String groupUpField = data['upField'] ?? '';
    String groupField = data['field'] ?? '';
    List<String> list = [groupUpField, groupField];
    list = list.where((item) => item != '').toList();
    return list.join('.');
  }

  List<Widget> _item(dynamic item, bool isLast) {
    double gutter = data['gutter'] ?? 0;

    item['upField'] = getUpField();

    return [
      buildField(item),
      if (!isLast) SizedBox(width: gutter),
    ];
  }
}
