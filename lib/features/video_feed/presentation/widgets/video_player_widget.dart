import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onTap;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (controller.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
            if (controller.value.isBuffering)
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            if (!controller.value.isPlaying && controller.value.isInitialized)
              const Icon(
                Icons.play_arrow_rounded,
                size: 72,
                color: Colors.white54,
              ),
          ],
        ),
      ),
    );
  }
}
