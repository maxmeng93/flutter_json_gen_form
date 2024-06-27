import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fijkplayer/fijkplayer.dart';

abstract class VideoPlayerInterface {
  void videoPlay();
  void videoPause();
}

class VideoPlayer extends StatefulWidget {
  final String uri;
  final bool autoPlay;

  const VideoPlayer({
    super.key,
    required this.uri,
    this.autoPlay = false,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer>
    implements VideoPlayerInterface {
  final FijkPlayer _player = FijkPlayer();

  /// 播放器状态
  late FijkState _state = FijkState.idle;

  @override
  void initState() {
    super.initState();
    _playerInit();
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.uri != widget.uri) {
      _playerReset();
    }
  }

  @override
  void dispose() {
    _player.removeListener(_playerListener);
    _player.release();
    super.dispose();
  }

  _playerInit() async {
    if (widget.uri.isEmpty) return;

    _player.addListener(_playerListener);

    await _player.setDataSource(widget.uri, autoPlay: widget.autoPlay);
  }

  void _playerListener() {
    FijkState state = _player.state;
    if (mounted) {
      setState(() {
        _state = state;
      });
    }
  }

  _playerReset() async {
    await _player.reset();
    await _playerInit();
  }

  @override
  void videoPlay() {
    _player.start();
  }

  @override
  void videoPause() {
    _player.pause();
  }

  @override
  Widget build(BuildContext context) {
    return FijkView(
      player: _player,
      fsFit: FijkFit.fill,
      fit: FijkFit.cover,
      panelBuilder: (
        FijkPlayer player,
        FijkData data,
        BuildContext context,
        Size viewSize,
        Rect texturePos,
      ) {
        return SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              /// 播放器异常
              if (_state == FijkState.error)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Play error',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text: 'Reload',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _playerReset();
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // 居中显示播放按钮icon
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_state == FijkState.paused) {
                        videoPlay();
                      } else if (_state == FijkState.started) {
                        videoPause();
                      }
                    },
                    child: Icon(
                      _state != FijkState.started
                          ? Icons.play_arrow
                          : Icons.pause,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
