import 'package:get/get.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/city_model.dart';
import '../../../../core/mock/mock_trips.dart';
import '../../../../core/mock/mock_cities.dart';

/// Dashboard controller
class DashboardController extends GetxController {
  // Observable state
  final RxList<TripModel> upcomingTrips = <TripModel>[].obs;
  final RxList<CityModel> popularCities = <CityModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load dashboard data from mock
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Simulate network delay for realistic feel
      await Future.delayed(const Duration(milliseconds: 500));

      // Load data from mock
      upcomingTrips.value = MockTrips.getUpcomingTrips();
      popularCities.value = MockCities.popularCities;
    } catch (e) {
      print('Dashboard load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh dashboard
  Future<void> refresh() async {
    await loadDashboardData();
  }

  /// Navigate to trips screen
  void goToTrips() {
    Get.toNamed('/trips');
  }

  /// Navigate to create trip
  void goToCreateTrip() {
    Get.toNamed('/create-trip');
  }

  /// Navigate to trip detail (itinerary)
  void goToTripDetail(String tripId) {
    Get.toNamed('/itinerary', arguments: {'tripId': tripId});
  }
}
