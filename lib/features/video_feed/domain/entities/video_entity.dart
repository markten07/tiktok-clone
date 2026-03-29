class VideoEntity {
  final String id;
  final String videoUrl;
  final String username;
  final String caption;
  final int likes;
  final int comments;
  final int shares;

  const VideoEntity({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}
