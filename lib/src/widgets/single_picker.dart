import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future showSinglePicker(
  context, {
  String? title,
  String? okText,
  String? cancelText,
  List<SinglePickerData>? options,
  bool? multiple,
  dynamic value,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000).withOpacity(0.6),
    builder: (BuildContext context) {
      return PickerWrap(
        title: title,
        okText: okText,
        cancelText: cancelText,
        value: value,
        options: options,
        multiple: multiple,
      );
    },
  );
}

class SinglePickerData {
  final String label;
  final dynamic value;

  const SinglePickerData({required this.label, required this.value});
}

class PickerWrap extends StatefulWidget {
  final List<SinglePickerData>? options;
  final dynamic value;
  final bool? multiple;
  final String? title;
  final String? okText;
  final String? cancelText;

  const PickerWrap({
    super.key,
    this.options,
    this.value,
    this.multiple,
    this.title,
    this.okText,
    this.cancelText,
  });

  @override
  State<PickerWrap> createState() => _PickerWrapState();
}

class _PickerWrapState extends State<PickerWrap> {
  final double headerHeight = 42;
  final double itemHeight = 34;
  dynamic _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _onChanged(dynamic value) {
    _value = value;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color bgColor = colorScheme.surfaceContainerHigh;

    final double height = headerHeight + itemHeight * 7;
    return Container(
      height: height,
      color: bgColor,
      child: Column(
        children: <Widget>[
          Container(
            height: headerHeight,
            color: bgColor,
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
                    style: TextStyle(fontSize: 15, color: colorScheme.primary),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title ?? '',
                      style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(_value);
                  },
                  child: Text(
                    widget.cancelText ?? '确定',
                    style: TextStyle(fontSize: 15, color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: itemHeight * 7,
            child: widget.multiple == true
                ? MultipleSinglePicker(
                    options: widget.options,
                    value: widget.value,
                    onChanged: _onChanged,
                    itemHeight: itemHeight,
                  )
                : SinglePicker(
                    options: widget.options,
                    value: widget.value,
                    onChanged: _onChanged,
                    itemHeight: itemHeight,
                  ),
          ),
        ],
      ),
    );
  }
}

class SinglePicker extends StatefulWidget {
  final dynamic value;
  final List<SinglePickerData>? options;
  final double itemHeight;
  final void Function(dynamic value) onChanged;

  const SinglePicker({
    super.key,
    required this.onChanged,
    required this.itemHeight,
    this.options = const [],
    this.value,
  });

  @override
  State<SinglePicker> createState() => _SinglePickerState();
}

class _SinglePickerState extends State<SinglePicker> {
  FixedExtentScrollController controller = FixedExtentScrollController();
  late List<SinglePickerData> _options = [];

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    initListData();
  }

  initListData() {
    _options = widget.options ?? [];
    final initialValue = widget.value;
    if (_options.isNotEmpty) {
      if (initialValue != null) {
        _selectedIndex =
            _options.indexWhere((item) => item.value == initialValue);
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

    if (_selectedIndex != null) {
      widget.onChanged(_options[_selectedIndex!].value);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color bgColor = colorScheme.surfaceContainerHigh;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: widget.itemHeight,
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
              height: widget.itemHeight * 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgColor, bgColor.withOpacity(0)],
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
              height: widget.itemHeight * 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [bgColor, bgColor.withOpacity(0.5)],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildList() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ScrollConfiguration(
      behavior: NoWaveBehavior(),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: widget.itemHeight,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (int index) {
          setState(() {
            _selectedIndex = index;
            widget.onChanged(_options[index].value);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: _options.length,
          builder: (BuildContext context, int index) {
            return SizedBox(
              height: widget.itemHeight,
              child: Center(
                child: Text(
                  _options[index].label.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MultipleSinglePicker extends StatefulWidget {
  final dynamic value;
  final List<SinglePickerData>? options;
  final double itemHeight;
  final void Function(dynamic value) onChanged;

  const MultipleSinglePicker({
    super.key,
    required this.onChanged,
    required this.itemHeight,
    this.options = const [],
    this.value,
  });

  @override
  State<MultipleSinglePicker> createState() => _MultipleSinglePickerState();
}

class _MultipleSinglePickerState extends State<MultipleSinglePicker> {
  final List _value = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final value = widget.value;
    if (value != null) {
      _value.addAll(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: widget.options!.map((item) {
          return _item(item);
        }).toList(),
      ),
    );
  }

  Widget _item(SinglePickerData item) {
    bool isSelected = _value.contains(item.value);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_value.contains(item.value)) {
            _value.remove(item.value);
          } else {
            _value.add(item.value);
          }
          widget.onChanged(_value);
        });
      },
      child: Container(
        height: widget.itemHeight,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(bottom: 2),
        color: isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent,
        child: Center(
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
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
