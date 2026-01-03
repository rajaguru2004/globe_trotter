import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/activity_model.dart';
import '../../../../core/mock/mock_trips.dart';
import '../../../../core/mock/mock_cities.dart';
import '../../../../core/mock/mock_activities.dart';

class ItineraryController extends GetxController {
  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final RxBool isLoading = false.obs;

  String? tripId;

  @override
  void onInit() {
    super.onInit();

    // Get trip ID from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    tripId = args?['tripId'];

    if (tripId != null) {
      loadTrip();
    }
  }

  /// Load trip data
  Future<void> loadTrip() async {
    try {
      isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      trip.value = MockTrips.getTripById(tripId!);
    } catch (e) {
      print('Load trip error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Show add city bottom sheet
  void showAddCitySheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Add City',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            // Cities List
            Expanded(
              child: ListView.builder(
                itemCount: MockCities.popularCities.length,
                itemBuilder: (context, index) {
                  final city = MockCities.popularCities[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(city.name),
                    subtitle: Text(city.country),
                    onTap: () {
                      Get.back();
                      addCity(city);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  /// Add city to trip
  void addCity(CityModel city) {
    if (trip.value == null) return;

    final uuid = const Uuid();
    final currentTrip = trip.value!;

    // Determine dates for new stop
    DateTime startDate;
    DateTime endDate;

    if (currentTrip.stops == null || currentTrip.stops!.isEmpty) {
      // First stop - use trip dates
      startDate = currentTrip.startDate;
      endDate = currentTrip.startDate.add(const Duration(days: 3));
    } else {
      // Add after last stop
      final lastStop = currentTrip.stops!.last;
      startDate = lastStop.endDate.add(const Duration(days: 1));
      endDate = startDate.add(const Duration(days: 3));
    }

    final newStop = TripStopModel(
      id: 'stop_${uuid.v4()}',
      tripId: currentTrip.id,
      city: city,
      startDate: startDate,
      endDate: endDate,
      order: (currentTrip.stops?.length ?? 0),
      activities: [],
      estimatedCost: 0.0,
    );

    final updatedStops = <TripStopModel>[...(currentTrip.stops ?? []), newStop];
    final updatedTrip = currentTrip.copyWith(stops: updatedStops);

    MockTrips.updateTrip(updatedTrip);
    trip.value = updatedTrip;

    Get.snackbar(
      'City Added',
      '${city.name} added to your trip',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Show add activity dialog
  void showAddActivityDialog(int stopIndex) {
    if (trip.value == null) return;

    final stop = trip.value!.stops![stopIndex];
    final activities = MockActivities.getActivitiesForCity(stop.city.id);

    Get.dialog(
      AlertDialog(
        title: Text('Add Activity in ${stop.city.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                title: Text(activity.name),
                subtitle: Text(
                  '${activity.costFormatted} • ${activity.durationFormatted}',
                ),
                trailing: const Icon(Icons.add),
                onTap: () {
                  Get.back();
                  addActivity(stopIndex, activity);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// Add activity to stop
  void addActivity(int stopIndex, ActivityModel activity) {
    if (trip.value == null) return;

    final currentTrip = trip.value!;
    final stops = List<TripStopModel>.from(currentTrip.stops ?? []);
    final stop = stops[stopIndex];

    final updatedActivities = <ActivityModel>[
      ...(stop.activities ?? []),
      activity,
    ];
    final updatedCost = updatedActivities.fold<double>(
      0.0,
      (sum, act) => sum + (act.cost ?? 0.0),
    );

    // Create updated stop (no copyWith method, so recreate)
    final updatedStop = TripStopModel(
      id: stop.id,
      tripId: stop.tripId,
      city: stop.city,
      startDate: stop.startDate,
      endDate: stop.endDate,
      order: stop.order,
      activities: updatedActivities,
      estimatedCost: updatedCost,
    );

    stops[stopIndex] = updatedStop;

    final updatedTrip = currentTrip.copyWith(stops: stops);
    MockTrips.updateTrip(updatedTrip);
    trip.value = updatedTrip;

    Get.snackbar(
      'Activity Added',
      '${activity.name} added',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navigate to budget screen
  void goToBudget() {
    Get.toNamed('/budget', arguments: {'tripId': tripId});
  }

  /// Navigate to timeline screen
  void goToTimeline() {
    Get.toNamed('/timeline', arguments: {'tripId': tripId});
  }

  /// Navigate to share screen
  void goToShare() {
    Get.toNamed('/share', arguments: {'tripId': tripId});
  }
}
