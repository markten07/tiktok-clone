import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_local_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoLocalDataSource _dataSource;

  const VideoRepositoryImpl(this._dataSource);

  @override
  Future<List<VideoEntity>> getVideos({
    required int page,
    int limit = 5,
  }) async {
    final models = await _dataSource.getVideos(page: page, limit: limit);
    return models.map((model) => model.toEntity()).toList();
  }
}
