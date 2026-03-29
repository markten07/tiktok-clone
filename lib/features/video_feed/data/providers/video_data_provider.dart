import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/video_local_datasource.dart';
import '../repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';

part 'video_data_provider.g.dart';

@Riverpod(keepAlive: true)
VideoLocalDataSource videoLocalDataSource(VideoLocalDataSourceRef ref) {
  return VideoLocalDataSourceImpl();
}

@Riverpod(keepAlive: true)
VideoRepository videoRepository(VideoRepositoryRef ref) {
  final dataSource = ref.watch(videoLocalDataSourceProvider);
  return VideoRepositoryImpl(dataSource);
}
