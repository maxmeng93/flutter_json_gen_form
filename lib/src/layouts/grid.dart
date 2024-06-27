import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final int rowCount;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const Grid({
    super.key,
    required this.itemBuilder,
    this.rowCount = 2,
    this.itemCount = 0,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    int rows = (itemCount / rowCount).ceil();

    return Column(
      children: [
        for (int i = 0; i < rows; i++) ...[
          Row(
            children: [
              for (int j = 0; j < rowCount; j++)
                if (i * rowCount + j < itemCount) ...[
                  Expanded(child: itemBuilder(context, i * rowCount + j)),
                  SizedBox(width: j < rowCount - 1 ? mainAxisSpacing : 0),
                ] else
                  const Expanded(child: SizedBox()),
            ],
          ),
          if (i < rows - 1) SizedBox(height: crossAxisSpacing),
        ],
      ],
    );
  }
}
