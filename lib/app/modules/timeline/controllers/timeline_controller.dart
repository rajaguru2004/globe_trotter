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

  /// Detect schedule conflicts
  Map<String, dynamic> detectConflicts() {
    if (trip.value == null) {
      return {'hasConflicts': false};
    }

    final conflicts = <String>[];
    int weekdayCount = 0;
    int overbookedDays = 0;
    final problematicDays = <DateTime>[];

    // Check for weekday conflicts
    DateTime currentDate = trip.value!.startDate;
    final endDate = trip.value!.endDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      // Check if it's a weekday (Monday = 1, Friday = 5)
      if (currentDate.weekday >= 1 && currentDate.weekday <= 5) {
        weekdayCount++;
        problematicDays.add(currentDate);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Check for overbooked days
    final activitiesByDay = getActivitiesByDay();
    activitiesByDay.forEach((day, items) {
      final activityCount = items.where((i) => i['type'] == 'activity').length;
      if (activityCount > 4) {
        overbookedDays++;
        if (!problematicDays.contains(day)) {
          problematicDays.add(day);
        }
      }
    });

    // Determine severity and create conflict messages
    String severity = 'none';
    if (weekdayCount > 0) {
      conflicts.add(
        'Trip includes $weekdayCount weekday${weekdayCount > 1 ? 's' : ''} - may conflict with work schedule',
      );
      severity = weekdayCount >= 3 ? 'critical' : 'warning';
    }

    if (overbookedDays > 0) {
      conflicts.add(
        '$overbookedDays day${overbookedDays > 1 ? 's' : ''} with 5+ activities - schedule may be too tight',
      );
      if (severity == 'none') severity = 'warning';
    }

    return {
      'hasConflicts': conflicts.isNotEmpty,
      'conflicts': conflicts,
      'severity': severity,
      'weekdayCount': weekdayCount,
      'overbookedDays': overbookedDays,
      'problematicDays': problematicDays,
    };
  }

  /// Get suggestions for resolving conflicts
  List<String> getConflictSuggestions() {
    final conflictData = detectConflicts();
    final suggestions = <String>[];

    if (conflictData['weekdayCount'] > 0) {
      suggestions.add('Consider moving the trip to weekend dates');
      suggestions.add('Request time off from work in advance');
    }

    if (conflictData['overbookedDays'] > 0) {
      suggestions.add('Reduce activities on busy days');
      suggestions.add('Spread activities across more days');
    }

    if (suggestions.isEmpty) {
      suggestions.add('Your schedule looks well-balanced!');
    }

    return suggestions;
  }

  /// Check if a specific day has conflicts
  bool isDayProblematic(DateTime day) {
    final conflictData = detectConflicts();
    final problematicDays = conflictData['problematicDays'] as List<DateTime>;
    return problematicDays.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
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
