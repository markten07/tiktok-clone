import 'package:flutter/material.dart';

import '../../domain/entities/video_entity.dart';
import 'action_button.dart';
import 'video_description.dart';

class VideoOverlayUi extends StatelessWidget {
  final VideoEntity video;
  final bool isLiked;
  final VoidCallback onLikeTap;

  const VideoOverlayUi({
    super.key,
    required this.video,
    required this.isLiked,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 하단 그라데이션
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 200,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        // 하단: Username, Caption
        Positioned(
          left: 0,
          right: 80,
          bottom: 16,
          child: VideoDescription(
            username: video.username,
            caption: video.caption,
          ),
        ),
        // 오른쪽: Like, Comment, Share
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: ActionButton.formatCount(
                  isLiked ? video.likes + 1 : video.likes,
                ),
                iconColor: isLiked ? const Color(0xFFFF2D55) : Colors.white,
                onTap: onLikeTap,
              ),
              const SizedBox(height: 20),
              ActionButton(
                icon: Icons.comment_rounded,
                label: ActionButton.formatCount(video.comments),
              ),
              const SizedBox(height: 20),
              ActionButton(
                icon: Icons.share_rounded,
                label: ActionButton.formatCount(video.shares),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
