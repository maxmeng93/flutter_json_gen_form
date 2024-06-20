import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
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
  bool multiple = false;

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
      multiple = data['multiple'] == true;

      field = data['field'];
      label = data['label'];
      initialValue = data['value'];
    });
  }

  _uploadFile(XFile file) async {
    // var f = File(file.path);
    // var stat = f.statSync();

    final extension = file.name.split('.').last;
    final data = await MultipartFile.fromFile(file.path);

    // print('file: ${file.path}');

    // try {
    //   var res = await uploadFiles({
    //     'upload_file': data,
    //   }, {
    //     'file_extension': '.$extension',
    //     'category': uploadCategory,
    //   });
    //   String url = res.data['data']['url'];
    //
    //   setState(() {
    //     _files[index] = UnitFileLink(
    //       fileLink: url,
    //       fileMark: _files[index].fileMark,
    //       fileType: _files[index].fileType,
    //     );
    //   });
    // } catch (e) {
    //   debugPrint('上传文件失败');
    // }
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
            InnerWrap(state: state, child: _media(state)),
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
    List<String> images = [];
    if (multiple) {
      images.addAll(state.value ?? []);
    } else {
      if (state.value != null) {
        images.add(state.value);
      }
    }

    return Grid(
      rowCount: 3,
      itemCount: images.length + ((multiple || images.isEmpty) ? 1 : 0),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemBuilder: (context, index) {
        if (index == images.length) {
          return _addMedia(state);
        }
        return _mediaItem(state, images[index]);
      },
    );
  }

  Widget _addMedia(FormFieldState state) {
    return GestureDetector(
      onTap: () {
        showSelectMultimedia(context, isMultiple: multiple).then((files) {
          if (files != null && files.isNotEmpty) {
            List<String> paths = [];
            for (var file in files) {
              paths.add(file.path);
              _uploadFile(file);
            }

            if (multiple) {
              List<String> all = [...state.value ?? [], ...paths];
              state.didChange(all);
              widget.onChanged(field, all);
            } else {
              state.didChange(paths.first);
              widget.onChanged(field, paths.first);
            }
          }
        });
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }

  Widget _mediaItem(FormFieldState state, String url) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _renderImage(url),
        ),
        Positioned(
          top: -5,
          right: -5,
          child: GestureDetector(
            onTap: () {
              if (multiple) {
                List<String> all = [...state.value ?? []];
                all.remove(url);
                state.didChange(all);
                widget.onChanged(field, all);
              } else {
                state.didChange(null);
                widget.onChanged(field, null);
              }
            },
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }

  _renderImage(String url) {
    bool isNetwork = url.startsWith('http');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              ImageProvider imageProvider = NetworkImage(url);
              if (!isNetwork) {
                imageProvider = FileImage(File(url));
              }

              return PhotoViewRouteWrapper(
                imageProvider: imageProvider,
              );
            },
          ),
        );
      },
      child: isNetwork
          ? Image.network(
              url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(url),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }

  _renderVideo(String url) {
    bool isNetwork = url.startsWith('http');

    return isNetwork
        ? Image.network(
            url,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(url),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
  }
}

/// 图片预览
class PhotoViewRouteWrapper extends StatelessWidget {
  const PhotoViewRouteWrapper({
    super.key,
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              imageProvider: imageProvider,
              backgroundDecoration: backgroundDecoration,
              minScale: minScale,
              maxScale: maxScale,
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return const Center(
                  child: Text(
                    '图片加载失败',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          // 关闭按钮
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
