class AppConstants {
  AppConstants._();

  static const int videosPerPage = 5;
  static const int preloadThreshold = 2;

  static const Duration likeAnimationDuration = Duration(milliseconds: 800);

  static const List<Map<String, dynamic>> mockVideos = [
    {
      'id': '1',
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'username': 'nature_lover',
      'caption': '꿀벌의 아름다운 비행 🐝 #자연 #꿀벌',
      'likes': 12400,
      'comments': 342,
      'shares': 89,
    },
    {
      'id': '2',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'username': 'movie_clips',
      'caption': '영화 속 한 장면 🎬 #영화 #시네마',
      'likes': 45200,
      'comments': 1203,
      'shares': 567,
    },
    {
      'id': '3',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'username': 'adventure_time',
      'caption': '대탈출! 짜릿한 모험 🏃‍♂️ #모험 #액션',
      'likes': 8900,
      'comments': 156,
      'shares': 45,
    },
    {
      'id': '4',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'username': 'fun_factory',
      'caption': '웃음이 필요한 순간 😂 #재미 #일상',
      'likes': 23100,
      'comments': 890,
      'shares': 234,
    },
    {
      'id': '5',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'username': 'speed_demon',
      'caption': '스피드의 짜릿함 🏎️ #드라이브 #스피드',
      'likes': 67800,
      'comments': 2340,
      'shares': 1200,
    },
  ];
}
