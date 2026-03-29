import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class GetVideosUsecase {
  final VideoRepository _repository;

  const GetVideosUsecase(this._repository);

  Future<List<VideoEntity>> call({required int page, int limit = 5}) {
    return _repository.getVideos(page: page, limit: limit);
  }
}
