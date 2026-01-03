import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/trip_model.dart';
import '../../../../core/mock/mock_trips.dart';

class TripsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final RxList<TripModel> upcomingTrips = <TripModel>[].obs;
  final RxList<TripModel> ongoingTrips = <TripModel>[].obs;
  final RxList<TripModel> completedTrips = <TripModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    loadTrips();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Load trips from mock data
  Future<void> loadTrips() async {
    try {
      isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      upcomingTrips.value = MockTrips.getUpcomingTrips();
      ongoingTrips.value = MockTrips.getOngoingTrips();
      completedTrips.value = MockTrips.getCompletedTrips();
    } catch (e) {
      print('Load trips error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete trip
  void deleteTrip(String tripId) {
    Get.defaultDialog(
      title: 'Delete Trip',
      middleText: 'Are you sure you want to delete this trip?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        MockTrips.deleteTrip(tripId);
        loadTrips(); // Reload trips
        Get.back(); // Close dialog
        Get.snackbar(
          'Deleted',
          'Trip deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Navigate to trip detail (itinerary)
  void goToTripDetail(String tripId) {
    Get.toNamed('/itinerary', arguments: {'tripId': tripId});
  }

  /// Refresh trips
  Future<void> refresh() async {
    await loadTrips();
  }
}
