import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
export 'package:image_picker/image_picker.dart' show XFile;

enum MultimediaTypeEnum {
  /// 图片
  image,

  /// 视频
  video,

  /// 图片和视频
  media,
}

/// 选择多媒体
Future<List<XFile>?> showSelectMultimedia(
  context, {
  MultimediaTypeEnum type = MultimediaTypeEnum.image,
  bool isMultiple = false,
}) {
  return showModalBottomSheet<List<XFile>?>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000).withOpacity(0.6),
    builder: (BuildContext context) {
      return SelectMultimedia(type: type, isMultiple: isMultiple);
    },
  );
}

/// 选择多媒体【图片、视频】
/// 直接从图库选择，或者拍照/摄像
class SelectMultimedia extends StatefulWidget {
  /// 资源类型。默认：图片和视频
  final MultimediaTypeEnum type;

  /// 多选。默认：否
  final bool isMultiple;

  const SelectMultimedia({
    super.key,
    this.type = MultimediaTypeEnum.media,
    this.isMultiple = false,
  });

  @override
  State<SelectMultimedia> createState() => _SelectMultimediaState();
}

class _SelectMultimediaState extends State<SelectMultimedia> {
  final ImagePicker _picker = ImagePicker();

  // 从图库选择
  _pick(BuildContext context) async {
    bool isMultiple = widget.isMultiple;
    MultimediaTypeEnum type = widget.type;
    List<XFile> files = [];

    if (isMultiple) {
      if (type == MultimediaTypeEnum.image) {
        files = await _picker.pickMultiImage();
      } else {
        files = await _picker.pickMultipleMedia();
      }
    } else {
      if (type == MultimediaTypeEnum.image) {
        XFile? file = await _picker.pickImage(source: ImageSource.gallery);
        if (file != null) files.add(file);
      } else if (type == MultimediaTypeEnum.video) {
        XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
        if (file != null) files.add(file);
      } else {
        XFile? file = await _picker.pickMedia();
        if (file != null) files.add(file);
      }
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(files);
  }

  // 摄像头
  _capture(BuildContext context) async {
    MultimediaTypeEnum type = widget.type;
    List<XFile> files = [];

    if (type == MultimediaTypeEnum.image) {
      XFile? file = await _picker.pickImage(source: ImageSource.camera);
      if (file != null) files.add(file);
    } else if (type == MultimediaTypeEnum.video) {
      XFile? file = await _picker.pickVideo(source: ImageSource.camera);
      if (file != null) files.add(file);
    } else {
      debugPrint('从摄像头捕获多媒体资源时，type不能选择MultimediaTypeEnum.media');
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(files);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color bgColor = colorScheme.surfaceContainerHigh;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            _item('拍照', (context) {
              _capture(context);
            }),
            _item('从手机相册选择', (context) {
              _pick(context);
            }),
            Container(color: colorScheme.surfaceContainerHighest, height: 10),
            _item('取消', (context) {
              Navigator.of(context).pop();
            }),
          ],
        ),
      ),
    );
  }

  _item(String text, Function(BuildContext context) onTap) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
      ),
      onTap: () {
        onTap(context);
      },
    );
  }
}
