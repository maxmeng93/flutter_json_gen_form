import 'package:flutter/material.dart';

Future showCascadePicker(
  context, {
  String? title,
  String? okText,
  String? cancelText,
  List<CascadePickerData>? options,
  bool? multiple,
  List<dynamic>? value,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000).withOpacity(0.6),
    builder: (BuildContext context) {
      return CascadePicker(
        title: title,
        okText: okText,
        cancelText: cancelText,
        value: value,
        options: options,
      );
    },
  );
}

class CascadePickerData {
  final String label;
  final dynamic value;
  final List<CascadePickerData>? children;

  const CascadePickerData({
    required this.label,
    required this.value,
    this.children,
  });
}

/// 级联选择器
class CascadePicker extends StatefulWidget {
  final List<CascadePickerData>? options;
  final List<dynamic>? value;
  final String? title;
  final String? okText;
  final String? cancelText;

  const CascadePicker({
    super.key,
    this.options,
    this.value,
    this.title,
    this.okText,
    this.cancelText,
  });

  @override
  State<CascadePicker> createState() => _CascadePickerState();
}

class _CascadePickerState extends State<CascadePicker>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();
  final double headerHeight = 42;
  final double itemHeight = 34;
  List<Tab> _tabs = [];
  List<List<CascadePickerData>> _tabsOptions = [];
  List<dynamic> _value = [];
  int _tabIndex = -1;

  List<CascadePickerData> get _curTabOptions {
    return _tabIndex >= 0 ? _tabsOptions[_tabIndex] : [];
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? [];

    List<CascadePickerData> options = widget.options ?? [];
    if (_value.isEmpty) {
      if (options.isNotEmpty) {
        _tabsOptions.add(options);
        _tabIndex = 0;
      }

      _tabs = [Tab(text: '请选择', height: itemHeight)];
      _tabController = TabController(vsync: this, length: _tabs.length);
    } else {
      List<Tab> tabs = [];
      final List<List<CascadePickerData>> tabsOptions = [options];
      for (var element in _getItemsChildren(_value, options)) {
        tabs.add(Tab(text: element.label, height: itemHeight));
        if (element.children != null) {
          tabsOptions.add(element.children!);
        }
      }
      _tabs = tabs;
      _tabsOptions = tabsOptions;
      _tabIndex = tabs.length - 1;
      _tabController = TabController(vsync: this, length: _tabs.length);
      _tabController?.index = _tabIndex;
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<CascadePickerData> _getItemsChildren(
      List<dynamic> values, List<CascadePickerData> data) {
    if (values.isEmpty) return [];

    var value = values[0];
    var item = data.firstWhere((item) => item.value == value);
    if (values.length == 1) return [item];

    return item.children != null
        ? [item, ..._getItemsChildren(values.sublist(1), item.children!)]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    final double height = headerHeight + itemHeight * 8;

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    Color bgColor = colorScheme.surfaceContainerHigh;

    return Container(
      height: height,
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      style: const TextStyle(fontSize: 15, color: Colors.black),
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
          TabBar(
            tabs: _tabs,
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerHeight: 0.5,
            dividerColor: colorScheme.onSurface.withOpacity(0.30),
            labelColor: colorScheme.primary,
            // 每个label的左右填充
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            unselectedLabelColor: colorScheme.onSurface,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: colorScheme.primary,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _curTabOptions.length,
              itemBuilder: (_, index) {
                return _item(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int index) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    CascadePickerData item = _curTabOptions[index];
    if (index < 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        setState(() {
          int newLength = _tabIndex + 1;
          if (_value.length > _tabIndex) {
            _value[_tabIndex] = item.value;
            _value.length = newLength;
          } else {
            _value.add(item.value);
          }
          _tabs[_tabIndex] = Tab(text: item.label, height: itemHeight);

          List<CascadePickerData>? children = item.children;
          if (children != null) {
            if (_tabsOptions.length > newLength) {
              _tabsOptions[newLength] = children;
              _tabsOptions.length = newLength + 1;
            } else {
              _tabsOptions.add(children);
            }

            Tab newTab = Tab(text: '请选择', height: itemHeight);
            if (_tabs.length > newLength) {
              _tabs[newLength] = newTab;
              _tabs.length = newLength + 1;
            } else {
              _tabs.add(newTab);
            }
            _tabController = TabController(
              vsync: this,
              length: newLength + 1,
            );

            _tabIndex = newLength;
            _tabController?.index = newLength;
          } else {
            _tabsOptions.length = newLength;
            _tabs.length = newLength;
            _tabController = TabController(vsync: this, length: newLength);
            _tabController?.index = newLength - 1;
          }
        });
      },
      child: Container(
        height: itemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.label,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
