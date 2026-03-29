import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/video_data_provider.dart';
import '../usecases/get_videos_usecase.dart';

part 'video_domain_provider.g.dart';

@Riverpod(keepAlive: true)
GetVideosUsecase getVideosUsecase(GetVideosUsecaseRef ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return GetVideosUsecase(repository);
}
