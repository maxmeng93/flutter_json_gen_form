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

  getChildField(child) {
    String groupField = data['field'] ?? '';
    String childField = child['field'] ?? '';
    List<String> list = [groupField, childField];
    list = list.where((item) => item != '').toList();
    return list.join('.');
  }

  List<Widget> _item(dynamic item, bool isLast) {
    double gutter = data['gutter'] ?? 0;

    item['field'] = getChildField(item);

    return [
      buildField(item),
      if (!isLast) SizedBox(width: gutter),
    ];
  }
}
