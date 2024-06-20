import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../validator/validator.dart';
import '../constants.dart';

class MediaControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;

  const MediaControl({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<MediaControl> createState() => _MediaControlState();
}

class _MediaControlState extends State<MediaControl> {
  late String field;
  String? label;
  dynamic initialValue;
  bool required = false;
  bool readonly = false;
  bool disabled = false;

  /// 规则
  List<dynamic>? rules;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    setState(() {
      final data = widget.data;

      rules = data['rules'];
      required = rules?.any((item) => item['required'] == true) ?? false;

      readonly = data['readonly'] == true;
      disabled = data['disabled'] == true;

      field = data['field'];
      label = data['label'];
      initialValue = data['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(label: label, required: required),
            GestureDetector(
              onTap: () {
                showSelectMultimedia(context, isMultiple: false).then((files) {
                  if (files != null && files.isNotEmpty) {
                    // _uploadFile(files.first, index);
                  }
                });
              },
              child: InnerInput(state: state, child: _media(state)),
            ),
            HelperError(state: state),
          ],
        );
      },
      validator: (value) {
        return validator(label, value, rules);
      },
    );
  }

  Widget _media(FormFieldState state) {
    return Container(
      child: Text('Media Control'),
    );
  }
}
