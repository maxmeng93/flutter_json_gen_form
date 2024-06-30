import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../widgets/widgets.dart';
import '../layouts/layouts.dart';
import '../validator/validator.dart';
import '../utils/utils.dart';

class MediaControl extends StatefulWidget {
  final dynamic data;
  final void Function(String field, dynamic value) onChanged;
  final Future<String> Function(String filePath, String field)? uploadFile;

  const MediaControl({
    super.key,
    required this.data,
    required this.onChanged,
    this.uploadFile,
  });

  @override
  State<MediaControl> createState() => _MediaControlState();
}

class _MediaControlState extends State<MediaControl> {
  late String field;
  String? label;
  dynamic initialValue;
  late String mediaType;
  bool required = false;
  bool readonly = false;
  bool disabled = false;
  bool multiple = false;
  List<dynamic>? rules;

  bool get onlyWatch => readonly || disabled;

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

      field = getField(data);
      label = data['label'];
      initialValue = data['value'];
      mediaType = data['mediaType'] ?? 'media';

      if (initialValue != null) {
        widget.onChanged(field, initialValue);
      }
    });
  }

  Future<void> _uploadFile(FormFieldState state, XFile file) async {
    if (widget.uploadFile != null) {
      final url = await widget.uploadFile!(file.path, field);
      if (multiple) {
        List<String> all = state.value ?? [];
        // 遍历all，根据file.path判断是否已经存在，如果存在则替换
        for (var i = 0; i < all.length; i++) {
          if (all[i] == file.path) {
            all[i] = url;
            break;
          }
        }
        state.didChange(all);
        widget.onChanged(field, all);
      } else {
        state.didChange(url);
        widget.onChanged(field, url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControlLabel(data: widget.data, required: required),
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
      itemCount: images.length +
          ((!onlyWatch && (multiple || images.isEmpty)) ? 1 : 0),
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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    MultimediaTypeEnum type = MultimediaTypeEnum.media;
    for (var item in MultimediaTypeEnum.values) {
      if (item.name == mediaType) {
        type = item;
        break;
      }
    }

    return GestureDetector(
      onTap: () {
        showSelectMultimedia(
          context,
          type: type,
          isMultiple: multiple,
        ).then((files) {
          if (files != null && files.isNotEmpty) {
            List<String> paths = [];
            for (var file in files) {
              paths.add(file.path);
              _uploadFile(state, file);
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
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: colorScheme.inverseSurface),
      ),
    );
  }

  Widget _mediaItem(FormFieldState state, String url) {
    final extension = url.split('.').last;
    List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
    bool isImage = imageExtensions.contains(extension);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: isImage ? _renderImage(url) : _renderVideo(url),
        ),
        Visibility(
          visible: !onlyWatch,
          child: Positioned(
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return VideoPlayerRouteWrapper(
                url: url,
              );
            },
          ),
        );
      },
      child: AbsorbPointer(child: VideoPlayer(uri: url)),
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

class VideoPlayerRouteWrapper extends StatelessWidget {
  final String url;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  const VideoPlayerRouteWrapper({
    super.key,
    required this.url,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: 200,
          child: VideoPlayer(uri: url, autoPlay: true),
        ),
      ),
    );
  }
}
