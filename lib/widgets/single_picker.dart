import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<SinglePickerSelectData?> showSinglePicker(
  context, {
  String? title,
  String? okText,
  String? cancelText,
  List<SinglePickerData>? data,
  dynamic value,
}) {
  return showModalBottomSheet<SinglePickerSelectData?>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000).withOpacity(0.6),
    builder: (BuildContext context) {
      return SinglePicker(
        title: title,
        okText: okText,
        cancelText: cancelText,
        value: value,
        data: data,
      );
    },
  );
}

class SinglePickerData {
  final String label;
  final dynamic value;

  const SinglePickerData({required this.label, required this.value});
}

class SinglePickerSelectData {
  final int? index;
  final dynamic value;

  const SinglePickerSelectData({required this.index, required this.value});
}

class SinglePicker extends StatefulWidget {
  final String? title;
  final String? okText;
  final String? cancelText;
  final List<SinglePickerData>? data;
  final dynamic value;

  const SinglePicker({
    super.key,
    this.title,
    this.okText,
    this.cancelText,
    this.data = const [],
    this.value,
  });

  @override
  State<SinglePicker> createState() => _SinglePickerState();
}

class _SinglePickerState extends State<SinglePicker> {
  FixedExtentScrollController controller = FixedExtentScrollController();
  late List<SinglePickerData> data = [];

  final double headerHeight = 42;
  final double itemHeight = 34;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    initListData();
  }

  initListData() {
    data = widget.data ?? [];
    if (data.isNotEmpty) {
      if (widget.value != null) {
        _selectedIndex = data.indexWhere((item) => item.value == widget.value);
        if (_selectedIndex == -1) _selectedIndex = 0;
      } else {
        _selectedIndex = 0;
      }
      if (_selectedIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.jumpToItem(_selectedIndex!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = headerHeight + itemHeight * 7;

    return Container(
      height: height,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: headerHeight,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.cancelText ?? '取消',
                    style: const TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title ?? '',
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(SinglePickerSelectData(
                      index: _selectedIndex,
                      value: _selectedIndex != null
                          ? data[_selectedIndex!].value
                          : null,
                    ));
                  },
                  child: Text(
                    widget.cancelText ?? '确定',
                    style: const TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: itemHeight * 7,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: itemHeight,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: buildList()),
                  ],
                ),
                // 蒙层
                Positioned(
                  top: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: itemHeight * 3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.white.withOpacity(0)],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: itemHeight * 3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.white, Colors.white.withOpacity(0.5)],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    final items = data;

    return ScrollConfiguration(
      behavior: NoWaveBehavior(),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: itemHeight,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (BuildContext context, int index) {
            return SizedBox(
              height: itemHeight,
              child: Center(
                child: Text(
                  items[index].label.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 去掉ListView上下滑动的波纹
class NoWaveBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final isAndroid = !kIsWeb && Platform.isAndroid;
    final isFuchsia = !kIsWeb && Platform.isFuchsia;
    if (isAndroid || isFuchsia) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }
}
