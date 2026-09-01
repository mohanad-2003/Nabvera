import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Inline exercise video: shows the poster image with a play button until
/// tapped, then streams `videoUrl` in place. Falls back to just the poster
/// (no player controls) if the video fails to load — a bad/expired link
/// shouldn't make the whole detail screen unusable.
class ExerciseVideoPlayer extends StatefulWidget {
  const ExerciseVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.poster,
  });

  final String videoUrl;
  final Widget poster;

  @override
  State<ExerciseVideoPlayer> createState() => ExerciseVideoPlayerState();
}

/// Public so a parent screen can hold a `GlobalKey<ExerciseVideoPlayerState>`
/// and trigger playback from its own button (e.g. a "Start Workout" CTA)
/// instead of only reacting to a tap on the poster.
class ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loading = false;
  bool _failed = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Starts playback if it hasn't already, otherwise resumes if paused.
  void play() {
    final controller = _controller;
    if (controller == null) {
      if (!_loading && !_failed) _play();
      return;
    }
    if (!controller.value.isPlaying) controller.play();
  }

  Future<void> _play() async {
    setState(() => _loading = true);
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await controller.initialize();
      await controller.play();
      controller.setLooping(true);
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (_) {
      controller.dispose();
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return GestureDetector(
        onTap: () {
          setState(() {
            controller.value.isPlaying ? controller.pause() : controller.play();
          });
        },
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.poster,
        if (!_failed)
          Center(
            child: GestureDetector(
              onTap: _loading ? null : _play,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
                child:
                    _loading
                        ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
              ),
            ),
          ),
      ],
    );
  }
}
