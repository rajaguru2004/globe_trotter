/// API Endpoints configuration for GlobeTrotter
/// Base URL: https://uaterp.skillhiveinnovations.com/api
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://uaterp.skillhiveinnovations.com/api';

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Dashboard Endpoints
  static const String dashboardOverview = '/dashboard/overview';

  // Trip Endpoints
  static const String trips = '/trips';
  static String tripDetail(String id) => '/trips/$id';
  static String updateTrip(String id) => '/trips/$id';
  static String deleteTrip(String id) => '/trips/$id';

  // Trip Stops (Cities) Endpoints
  static String tripStops(String tripId) => '/trips/$tripId/stops';
  static String stopDetail(String stopId) => '/stops/$stopId';
  static String updateStop(String stopId) => '/stops/$stopId';
  static String deleteStop(String stopId) => '/stops/$stopId';

  // Activity Endpoints
  static String stopActivities(String stopId) => '/stops/$stopId/activities';
  static String activityDetail(String activityId) => '/activities/$activityId';
  static String updateActivity(String activityId) => '/activities/$activityId';
  static String deleteActivity(String activityId) => '/activities/$activityId';

  // Budget Endpoints
  static String tripBudget(String tripId) => '/trips/$tripId/budget';
  static String budgetBreakdown(String tripId) =>
      '/trips/$tripId/budget/breakdown';

  // Calendar & Timeline Endpoints
  static String tripCalendar(String tripId) => '/trips/$tripId/calendar';
  static String tripTimeline(String tripId) => '/trips/$tripId/timeline';

  // Search Endpoints
  static const String citySearch = '/cities/search';
  static const String activitySearch = '/activities/search';
  static String cityDetail(String cityId) => '/cities/$cityId';

  // Share & Community Endpoints
  static String tripShare(String tripId) => '/trips/$tripId/share';
  static String sharedTrip(String slug) => '/shared/$slug';
  static const String communityFeed = '/community/feed';
  static String copyTrip(String tripId) => '/trips/$tripId/copy';

  // User Profile Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String deleteAccount = '/users/account';
  static const String userTrips = '/users/trips';
  static const String userDrafts = '/users/drafts';

  // Master Data Endpoints (for dropdowns/references)
  static const String cities = '/cities';
  static const String activityCategories = '/activities/categories';
  static const String currencies = '/currencies';
}
