import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/like_animation_overlay.dart';
import '../../domain/entities/video_entity.dart';
import '../providers/video_feed_provider.dart';
import '../widgets/video_overlay_ui.dart';
import '../widgets/video_player_widget.dart';

class VideoFeedScreen extends ConsumerStatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  ConsumerState<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends ConsumerState<VideoFeedScreen> {
  final PageController _pageController = PageController();
  final Map<int, VideoPlayerController> _controllers = {};

  int _currentIndex = 0;
  bool _isInitialized = false;

  // 더블탭 좋아요 애니메이션 상태
  Offset? _doubleTapPosition;
  bool _showLikeAnimation = false;

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // VideoPlayerController 라이프사이클 관리
  // ---------------------------------------------------------------------------

  /// 현재 페이지 ± 1 윈도우만 컨트롤러 유지 (최대 3개)
  Future<void> _updateControllers(int index, List<VideoEntity> videos) async {
    final windowIndices = <int>{
      if (index > 0) index - 1,
      index,
      if (index < videos.length - 1) index + 1,
    };

    // 윈도우 밖 컨트롤러 정리
    final toRemove = _controllers.keys
        .where((i) => !windowIndices.contains(i))
        .toList();
    for (final i in toRemove) {
      await _controllers[i]?.dispose();
      _controllers.remove(i);
    }

    // 윈도우 안 컨트롤러 초기화
    for (final i in windowIndices) {
      if (!_controllers.containsKey(i)) {
        _initializeController(i, videos[i].videoUrl);
      }
    }

    // 현재 페이지만 재생, 나머지 일시정지
    for (final entry in _controllers.entries) {
      if (entry.key == index) {
        if (entry.value.value.isInitialized && !entry.value.value.isPlaying) {
          entry.value.play();
        }
      } else {
        if (entry.value.value.isPlaying) {
          entry.value.pause();
        }
      }
    }
  }

  Future<void> _initializeController(int index, String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controllers[index] = controller;

    await controller.initialize();
    controller.setLooping(true);

    if (index == _currentIndex && mounted) {
      controller.play();
    }

    if (mounted) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // 이벤트 핸들러
  // ---------------------------------------------------------------------------

  void _onPageChanged(int index, List<VideoEntity> videos) {
    setState(() => _currentIndex = index);
    _updateControllers(index, videos);

    // 무한 스크롤: 끝에서 preloadThreshold 전에 추가 로드
    if (index >= videos.length - AppConstants.preloadThreshold) {
      ref.read(videoFeedNotifierProvider.notifier).loadMoreVideos();
    }
  }

  void _togglePlayPause() {
    final controller = _controllers[_currentIndex];
    if (controller == null || !controller.value.isInitialized) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  void _onDoubleTap(VideoEntity video) {
    final notifier = ref.read(videoFeedNotifierProvider.notifier);
    if (!notifier.isLiked(video.id)) {
      notifier.toggleLike(video.id);
    }
    setState(() => _showLikeAnimation = true);
  }

  // ---------------------------------------------------------------------------
  // 빌드
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final asyncFeedState = ref.watch(videoFeedNotifierProvider);

    return Scaffold(
      body: asyncFeedState.when(
        data: (feedState) {
          final videos = feedState.videos;
          if (videos.isEmpty) {
            return const Center(child: Text('영상이 없습니다'));
          }

          // 최초 데이터 로드 시 컨트롤러 초기화
          if (!_isInitialized) {
            _isInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateControllers(0, videos);
            });
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            onPageChanged: (index) => _onPageChanged(index, videos),
            itemBuilder: (context, index) =>
                _buildVideoPage(index, videos[index], feedState),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
      ),
    );
  }

  Widget _buildVideoPage(
    int index,
    VideoEntity video,
    VideoFeedState feedState,
  ) {
    final controller = _controllers[index];
    final isLiked = feedState.likedVideoIds.contains(video.id);

    return GestureDetector(
      onDoubleTapDown: (details) {
        _doubleTapPosition = details.localPosition;
      },
      onDoubleTap: () => _onDoubleTap(video),
      child: Stack(
        children: [
          // 비디오 플레이어
          if (controller != null && controller.value.isInitialized)
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                return VideoPlayerWidget(
                  controller: controller,
                  onTap: _togglePlayPause,
                );
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // 오버레이 UI
          VideoOverlayUi(
            video: video,
            isLiked: isLiked,
            onLikeTap: () {
              ref.read(videoFeedNotifierProvider.notifier).toggleLike(video.id);
            },
          ),

          // 더블탭 좋아요 애니메이션
          if (_showLikeAnimation && _currentIndex == index && _doubleTapPosition != null)
            LikeAnimationOverlay(
              position: _doubleTapPosition!,
              onAnimationComplete: () {
                setState(() => _showLikeAnimation = false);
              },
            ),
        ],
      ),
    );
  }
}
