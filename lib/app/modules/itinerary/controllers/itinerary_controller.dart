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
  final RxBool isSaving = false.obs;

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
    final searchController = TextEditingController();
    final filteredCities = MockCities.popularCities.obs;
    final searchText = ''.obs;

    void filterCities(String query) {
      searchText.value = query;
      if (query.isEmpty) {
        filteredCities.value = MockCities.popularCities;
      } else {
        filteredCities.value = MockCities.popularCities
            .where(
              (city) =>
                  city.name.toLowerCase().contains(query.toLowerCase()) ||
                  city.country.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    }

    Get.bottomSheet(
      Container(
        height: Get.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header & Search
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Add Destination',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose a city for your trip',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: filterCities,
                        decoration: InputDecoration(
                          hintText: 'Search cities...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: searchText.value.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    filterCities('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cities Grid
            Expanded(
              child: Obx(() {
                if (filteredCities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cities found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = filteredCities[index];
                    return _buildCityCard(context, city);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
    );
  }

  /// Build city card widget
  Widget _buildCityCard(BuildContext context, CityModel city) {
    return GestureDetector(
      onTap: () {
        Get.back();
        addCity(city);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // City Image
              if (city.imageUrl != null)
                Image.asset(
                  city.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue[300]!, Colors.purple[300]!],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_city,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                )
              else
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue[300]!, Colors.purple[300]!],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_city,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),

              // City Info
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      city.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            city.country,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Add Icon
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, size: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
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

  /// Save trip
  Future<void> saveTrip() async {
    if (trip.value == null) return;

    try {
      isSaving.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Update trip in mock data
      MockTrips.updateTrip(trip.value!);

      Get.snackbar(
        'Success',
        'Trip saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save trip',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
