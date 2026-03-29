import '../../domain/entities/video_entity.dart';

class VideoModel {
  final String id;
  final String videoUrl;
  final String username;
  final String caption;
  final int likes;
  final int comments;
  final int shares;

  const VideoModel({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      username: json['username'] as String,
      caption: json['caption'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
    );
  }

  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      videoUrl: videoUrl,
      username: username,
      caption: caption,
      likes: likes,
      comments: comments,
      shares: shares,
    );
  }
}
