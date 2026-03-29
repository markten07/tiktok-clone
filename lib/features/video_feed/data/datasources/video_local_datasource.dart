import '../../../../core/constants/app_constants.dart';
import '../models/video_model.dart';

abstract class VideoLocalDataSource {
  Future<List<VideoModel>> getVideos({required int page, int limit});
}

class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  @override
  Future<List<VideoModel>> getVideos({
    required int page,
    int limit = AppConstants.videosPerPage,
  }) async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    final mockData = AppConstants.mockVideos;
    final List<VideoModel> videos = [];

    for (int i = 0; i < limit; i++) {
      final dataIndex = (page * limit + i) % mockData.length;
      final data = Map<String, dynamic>.from(mockData[dataIndex]);
      // 페이지별 고유 ID 생성
      data['id'] = '${data['id']}_page${page}_$i';

      videos.add(VideoModel.fromJson(data));
    }

    return videos;
  }
}
