/// Image service for handling travel images from Unsplash and fallbacks
class ImageService {
  ImageService._();

  // Unsplash Source API base URL
  static const String _unsplashBaseUrl = 'https://source.unsplash.com';

  // Default dimensions
  static const String _defaultSize = '800x600';
  static const String _thumbnailSize = '400x300';
  static const String _largeSize = '1200x800';

  /// Get city image URL from Unsplash
  static String getCityImageUrl(String cityName, {bool thumbnail = false}) {
    final size = thumbnail ? _thumbnailSize : _defaultSize;
    final query = '${cityName.replaceAll(' ', '+')}+city+skyline+travel';
    return '$_unsplashBaseUrl/$size/?$query';
  }

  /// Get activity image URL from Unsplash
  static String getActivityImageUrl(
    String activityType, {
    bool thumbnail = false,
  }) {
    final size = thumbnail ? _thumbnailSize : _defaultSize;
    final query = '${activityType.replaceAll(' ', '+')}+activity+travel';
    return '$_unsplashBaseUrl/$size/?$query';
  }

  /// Get generic travel image URL
  static String getTravelImageUrl(String keyword, {bool thumbnail = false}) {
    final size = thumbnail ? _thumbnailSize : _defaultSize;
    final query = '${keyword.replaceAll(' ', '+')}+travel';
    return '$_unsplashBaseUrl/$size/?$query';
  }

  /// Get large hero image URL
  static String getHeroImageUrl(String keyword) {
    final query = '${keyword.replaceAll(' ', '+')}+travel+landscape';
    return '$_unsplashBaseUrl/$_largeSize/?$query';
  }

  /// Get placeholder image path (local assets)
  static String getPlaceholderImage({String type = 'default'}) {
    switch (type) {
      case 'city':
        return 'assets/images/placeholder_city.png';
      case 'activity':
        return 'assets/images/placeholder_activity.png';
      case 'trip':
        return 'assets/images/placeholder_trip.png';
      default:
        return 'assets/images/placeholder_default.png';
    }
  }

  /// Build URL with custom parameters
  static String buildCustomUrl({
    required String query,
    int width = 800,
    int height = 600,
    String? specificId,
  }) {
    if (specificId != null) {
      return '$_unsplashBaseUrl/${width}x$height/$specificId';
    }
    final searchQuery = query.replaceAll(' ', '+');
    return '$_unsplashBaseUrl/${width}x$height/?$searchQuery';
  }

  /// Get category-based travel images
  static String getCategoryImageUrl(String category) {
    final categoryQueries = {
      'adventure': 'adventure+hiking+mountains+travel',
      'beach': 'beach+ocean+tropical+paradise',
      'cultural': 'culture+museum+architecture+heritage',
      'food': 'food+cuisine+restaurant+dining',
      'nature': 'nature+landscape+wilderness',
      'relaxation': 'spa+relaxation+wellness+resort',
      'sightseeing': 'landmarks+tourist+attractions+sightseeing',
      'nightlife': 'nightlife+city+lights+entertainment',
      'shopping': 'shopping+market+bazaar',
      'sports': 'sports+outdoor+activities',
    };

    final query =
        categoryQueries[category.toLowerCase()] ??
        '${category.replaceAll(' ', '+')}+travel';
    return '$_unsplashBaseUrl/$_defaultSize/?$query';
  }
}
