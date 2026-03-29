import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/video_entity.dart';
import '../../domain/providers/video_domain_provider.dart';

part 'video_feed_provider.g.dart';

class VideoFeedState {
  final List<VideoEntity> videos;
  final Set<String> likedVideoIds;
  final int currentPage;
  final bool isLoadingMore;

  const VideoFeedState({
    this.videos = const [],
    this.likedVideoIds = const {},
    this.currentPage = 0,
    this.isLoadingMore = false,
  });

  VideoFeedState copyWith({
    List<VideoEntity>? videos,
    Set<String>? likedVideoIds,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return VideoFeedState(
      videos: videos ?? this.videos,
      likedVideoIds: likedVideoIds ?? this.likedVideoIds,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@riverpod
class VideoFeedNotifier extends _$VideoFeedNotifier {
  @override
  Future<VideoFeedState> build() async {
    final usecase = ref.watch(getVideosUsecaseProvider);
    final videos = await usecase(page: 0);
    return VideoFeedState(videos: videos);
  }

  Future<void> loadMoreVideos() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLoadingMore) return;

    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    final usecase = ref.read(getVideosUsecaseProvider);
    final nextPage = currentState.currentPage + 1;
    final newVideos = await usecase(page: nextPage);

    state = AsyncData(currentState.copyWith(
      videos: [...currentState.videos, ...newVideos],
      currentPage: nextPage,
      isLoadingMore: false,
    ));
  }

  void toggleLike(String videoId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final likedIds = Set<String>.from(currentState.likedVideoIds);
    if (likedIds.contains(videoId)) {
      likedIds.remove(videoId);
    } else {
      likedIds.add(videoId);
    }

    state = AsyncData(currentState.copyWith(likedVideoIds: likedIds));
  }

  bool isLiked(String videoId) {
    return state.valueOrNull?.likedVideoIds.contains(videoId) ?? false;
  }
}
