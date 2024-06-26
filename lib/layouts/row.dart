import 'package:flutter/material.dart';

class RowLayout extends StatelessWidget {
  final dynamic data;
  final Widget Function(Map<String, dynamic> config) buildField;

  const RowLayout({
    super.key,
    required this.data,
    required this.buildField,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> children = data['children'] ?? [];
    children = children.where((item) => item['type'] == 'col').toList();

    return Row(
      children: children
          .map(
            (item) {
              bool isLast = children.indexOf(item) == children.length - 1;
              return _item(item, isLast);
            },
          )
          .expand((x) => x)
          .toList(),
    );
  }

  List<Widget> _item(dynamic item, bool isLast) {
    double gutter = data['gutter'].toDouble() ?? 0;

    item['child']['upField'] = data['upField'];

    return [
      Expanded(
        flex: item['flex'] ?? 1,
        child: buildField(item['child']),
      ),
      if (!isLast) SizedBox(width: gutter),
    ];
  }
}
