import 'package:globe_trotter_1/app/data/models/trip_model.dart';

import 'mock_cities.dart';
import 'mock_activities.dart';

/// Mock data for trips
class MockTrips {
  static final String _mockUserId = 'user_123';

  /// In-memory storage for trips (can be modified)
  static final List<TripModel> _trips = [
    // Upcoming Trip 1: European Adventure
    TripModel(
      id: 'trip_1',
      userId: _mockUserId,
      name: 'European Adventure',
      description: 'A dream trip across iconic European cities',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 42)),
      status: TripStatus.upcoming,
      coverImage: 'assets/1.jpeg',
      isPublic: true,
      shareSlug: 'european-adventure-2026',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      stops: [
        TripStopModel(
          id: 'stop_1_1',
          tripId: 'trip_1',
          city: MockCities.getCityById('city_1')!, // Paris
          startDate: DateTime.now().add(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 34)),
          order: 0,
          activities: [
            MockActivities.getActivityById('act_paris_1')!,
            MockActivities.getActivityById('act_paris_2')!,
            MockActivities.getActivityById('act_paris_3')!,
            MockActivities.getActivityById('act_paris_4')!,
          ],
          estimatedCost: 143.00,
        ),
        TripStopModel(
          id: 'stop_1_2',
          tripId: 'trip_1',
          city: MockCities.getCityById('city_4')!, // Rome
          startDate: DateTime.now().add(const Duration(days: 35)),
          endDate: DateTime.now().add(const Duration(days: 38)),
          order: 1,
          activities: [
            MockActivities.getActivityById('act_rome_1')!,
            MockActivities.getActivityById('act_rome_2')!,
            MockActivities.getActivityById('act_rome_3')!,
          ],
          estimatedCost: 130.00,
        ),
        TripStopModel(
          id: 'stop_1_3',
          tripId: 'trip_1',
          city: MockCities.getCityById('city_6')!, // Barcelona
          startDate: DateTime.now().add(const Duration(days: 39)),
          endDate: DateTime.now().add(const Duration(days: 42)),
          order: 2,
          activities: [
            MockActivities.getActivityById('act_bcn_1')!,
            MockActivities.getActivityById('act_bcn_2')!,
            MockActivities.getActivityById('act_bcn_3')!,
          ],
          estimatedCost: 86.00,
        ),
      ],
      totalBudget: 2500.00,
      actualCost: 359.00,
    ),

    // Upcoming Trip 2: Asian Discovery
    TripModel(
      id: 'trip_2',
      userId: _mockUserId,
      name: 'Asian Discovery',
      description: 'Exploring the wonders of Asia',
      startDate: DateTime.now().add(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 70)),
      status: TripStatus.upcoming,
      coverImage: 'assets/2.jpeg',
      isPublic: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      stops: [
        TripStopModel(
          id: 'stop_2_1',
          tripId: 'trip_2',
          city: MockCities.getCityById('city_2')!, // Tokyo
          startDate: DateTime.now().add(const Duration(days: 60)),
          endDate: DateTime.now().add(const Duration(days: 65)),
          order: 0,
          activities: [
            MockActivities.getActivityById('act_tokyo_1')!,
            MockActivities.getActivityById('act_tokyo_2')!,
            MockActivities.getActivityById('act_tokyo_3')!,
          ],
          estimatedCost: 11600.00,
        ),
        TripStopModel(
          id: 'stop_2_2',
          tripId: 'trip_2',
          city: MockCities.getCityById('city_9')!, // Bali
          startDate: DateTime.now().add(const Duration(days: 66)),
          endDate: DateTime.now().add(const Duration(days: 70)),
          order: 1,
          activities: [],
          estimatedCost: 0.00,
        ),
      ],
      totalBudget: 3000.00,
      actualCost: 11600.00,
    ),

    // Ongoing Trip: New York City Break
    TripModel(
      id: 'trip_3',
      userId: _mockUserId,
      name: 'NYC City Break',
      description: 'Weekend getaway in the Big Apple',
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 3)),
      status: TripStatus.ongoing,
      coverImage: 'assets/3.jpeg',
      isPublic: true,
      shareSlug: 'nyc-city-break',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
      stops: [
        TripStopModel(
          id: 'stop_3_1',
          tripId: 'trip_3',
          city: MockCities.getCityById('city_3')!, // New York
          startDate: DateTime.now().subtract(const Duration(days: 2)),
          endDate: DateTime.now().add(const Duration(days: 3)),
          order: 0,
          activities: [
            MockActivities.getActivityById('act_ny_1')!,
            MockActivities.getActivityById('act_ny_2')!,
            MockActivities.getActivityById('act_ny_3')!,
          ],
          estimatedCost: 219.00,
        ),
      ],
      totalBudget: 1200.00,
      actualCost: 219.00,
    ),

    // Completed Trip: London Calling
    TripModel(
      id: 'trip_4',
      userId: _mockUserId,
      name: 'London Calling',
      description: 'A memorable trip to the UK capital',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 54)),
      status: TripStatus.completed,
      coverImage: 'assets/5.jpeg',
      isPublic: true,
      shareSlug: 'london-calling-2025',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now().subtract(const Duration(days: 54)),
      stops: [
        TripStopModel(
          id: 'stop_4_1',
          tripId: 'trip_4',
          city: MockCities.getCityById('city_5')!, // London
          startDate: DateTime.now().subtract(const Duration(days: 60)),
          endDate: DateTime.now().subtract(const Duration(days: 54)),
          order: 0,
          activities: [
            MockActivities.getActivityById('act_london_1')!,
            MockActivities.getActivityById('act_london_2')!,
            MockActivities.getActivityById('act_london_3')!,
            MockActivities.getActivityById('act_london_4')!,
            MockActivities.getActivityById('act_london_5')!,
          ],
          estimatedCost: 136.00,
        ),
      ],
      totalBudget: 1500.00,
      actualCost: 1456.00,
    ),
  ];

  /// Get all trips
  static List<TripModel> getAllTrips() {
    return List.unmodifiable(_trips);
  }

  /// Get trips by status
  static List<TripModel> getTripsByStatus(TripStatus status) {
    return _trips.where((trip) => trip.status == status).toList();
  }

  /// Get trip by ID
  static TripModel? getTripById(String id) {
    try {
      return _trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new trip
  static void addTrip(TripModel trip) {
    _trips.insert(0, trip);
  }

  /// Update a trip
  static void updateTrip(TripModel updatedTrip) {
    final index = _trips.indexWhere((trip) => trip.id == updatedTrip.id);
    if (index != -1) {
      _trips[index] = updatedTrip;
    }
  }

  /// Delete a trip
  static void deleteTrip(String tripId) {
    _trips.removeWhere((trip) => trip.id == tripId);
  }

  /// Get upcoming trips
  static List<TripModel> getUpcomingTrips() {
    return getTripsByStatus(TripStatus.upcoming);
  }

  /// Get ongoing trips
  static List<TripModel> getOngoingTrips() {
    return getTripsByStatus(TripStatus.ongoing);
  }

  /// Get completed trips
  static List<TripModel> getCompletedTrips() {
    return getTripsByStatus(TripStatus.completed);
  }

  /// Get trip count
  static int getTripCount() {
    return _trips.length;
  }

  /// Get mock user ID
  static String getMockUserId() {
    return _mockUserId;
  }
}
