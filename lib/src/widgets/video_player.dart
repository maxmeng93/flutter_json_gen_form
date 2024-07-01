import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWrap extends StatefulWidget {
  final String uri;
  final bool autoPlay;
  final bool fullScreen;

  const VideoPlayerWrap({
    super.key,
    required this.uri,
    this.autoPlay = false,
    this.fullScreen = false,
  });

  @override
  State<VideoPlayerWrap> createState() => _VideoPlayerWrapState();
}

class _VideoPlayerWrapState extends State<VideoPlayerWrap> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    bool isNetwork = widget.uri.startsWith('http');
    if (isNetwork) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.uri));
    } else {
      _controller = VideoPlayerController.file(File(widget.uri));
    }

    _controller.initialize().then((_) {
      if (widget.autoPlay) {
        _controller.play();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Center(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          )
        : Container();
  }
}
