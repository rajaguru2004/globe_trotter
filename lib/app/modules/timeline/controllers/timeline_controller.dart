import 'package:get/get.dart';
import '../../../data/models/trip_model.dart';
import '../../../../core/mock/mock_trips.dart';

class TimelineController extends GetxController {
  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTimelineView = true.obs; // true = Timeline, false = Calendar

  String? tripId;

  @override
  void onInit() {
    super.onInit();

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

      await Future.delayed(const Duration(milliseconds: 300));

      trip.value = MockTrips.getTripById(tripId!);
    } catch (e) {
      print('Load trip error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle view
  void toggleView() {
    isTimelineView.value = !isTimelineView.value;
  }

  /// Get activities grouped by day
  Map<DateTime, List<dynamic>> getActivitiesByDay() {
    if (trip.value == null || trip.value!.stops == null) {
      return {};
    }

    final Map<DateTime, List<dynamic>> activitiesByDay = {};

    for (var stop in trip.value!.stops!) {
      if (stop.activities == null) continue;

      // Distribute activities across days in the stop
      final days = stop.numberOfDays;
      final activitiesPerDay = (stop.activities!.length / days).ceil();

      DateTime currentDate = DateTime(
        stop.startDate.year,
        stop.startDate.month,
        stop.startDate.day,
      );

      int activityIndex = 0;
      for (int day = 0; day < days; day++) {
        final dayActivities = <dynamic>[];

        // Add city info for first day
        if (day == 0) {
          dayActivities.add({'type': 'city', 'data': stop.city});
        }

        // Add activities for this day
        for (
          int i = 0;
          i < activitiesPerDay && activityIndex < stop.activities!.length;
          i++
        ) {
          dayActivities.add({
            'type': 'activity',
            'data': stop.activities![activityIndex],
          });
          activityIndex++;
        }

        activitiesByDay[currentDate] = dayActivities;
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    return activitiesByDay;
  }
}
