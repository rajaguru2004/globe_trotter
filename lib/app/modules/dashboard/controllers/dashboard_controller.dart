import 'package:get/get.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/trip_repository.dart';
import '../../auth/controllers/auth_controller.dart';

/// Dashboard controller
class DashboardController extends GetxController {
  final TripRepository _tripRepository = TripRepository();
  final AuthController _authController = Get.find<AuthController>();

  // Observable state
  final RxList<TripModel> upcomingTrips = <TripModel>[].obs;
  final RxList<CityModel> popularCities = <CityModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  UserModel? get currentUser => _authController.currentUser.value;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load dashboard data
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load dashboard overview
      final overview = await _tripRepository.getDashboardOverview();

      // Parse upcoming trips
      if (overview['upcomingTrips'] != null) {
        upcomingTrips.value = (overview['upcomingTrips'] as List)
            .map((trip) => TripModel.fromJson(trip))
            .toList();
      }

      // Parse popular cities
      if (overview['popularCities'] != null) {
        popularCities.value = (overview['popularCities'] as List)
            .map((city) => CityModel.fromJson(city))
            .toList();
      }

      // If overview doesn't provide these, fetch separately
      if (upcomingTrips.isEmpty) {
        await loadUpcomingTrips();
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Dashboard load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load upcoming trips
  Future<void> loadUpcomingTrips() async {
    try {
      final trips = await _tripRepository.getTrips(status: TripStatus.upcoming);
      upcomingTrips.value = trips.take(5).toList();
    } catch (e) {
      print('Load upcoming trips error: $e');
    }
  }

  /// Refresh dashboard
  Future<void> refresh() async {
    await loadDashboardData();
  }

  /// Navigate to trips screen
  void goToTrips() {
    // TODO: Navigate to trips screen when implemented
    Get.snackbar('Coming Soon', 'Trips screen coming soon');
  }

  /// Navigate to create trip
  void goToCreateTrip() {
    // TODO: Navigate to create trip screen when implemented
    Get.snackbar('Coming Soon', 'Create trip screen coming soon');
  }

  /// Navigate to trip detail
  void goToTripDetail(String tripId) {
    // TODO: Navigate to trip detail when implemented
    Get.snackbar('Coming Soon', 'Trip detail screen coming soon');
  }
}
