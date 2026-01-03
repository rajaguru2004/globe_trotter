import 'package:dio/dio.dart';
import '../models/trip_model.dart';
import '../models/city_model.dart';
import '../providers/api_client.dart';
import '../endpoints.dart';

/// Trip repository for trip-related API calls
class TripRepository {
  final ApiClient _apiClient = ApiClient();

  /// Get all trips for current user
  Future<List<TripModel>> getTrips({TripStatus? status}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.trips,
        queryParameters: status != null ? {'status': status.name} : null,
      );

      final tripsData = response.data['trips'] ?? response.data;
      if (tripsData is List) {
        return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw e.message ?? 'Failed to load trips';
    } catch (e) {
      throw 'Failed to load trips: $e';
    }
  }

  /// Get trip by ID
  Future<TripModel> getTripDetail(String tripId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.tripDetail(tripId));
      return TripModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to load trip details';
    } catch (e) {
      throw 'Failed to load trip details: $e';
    }
  }

  /// Create new trip
  Future<TripModel> createTrip({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    String? coverImage,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.trips,
        data: {
          'name': name,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          if (description != null) 'description': description,
          if (coverImage != null) 'coverImage': coverImage,
        },
      );

      return TripModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to create trip';
    } catch (e) {
      throw 'Failed to create trip: $e';
    }
  }

  /// Update trip
  Future<TripModel> updateTrip(String tripId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateTrip(tripId),
        data: data,
      );

      return TripModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to update trip';
    } catch (e) {
      throw 'Failed to update trip: $e';
    }
  }

  /// Delete trip
  Future<void> deleteTrip(String tripId) async {
    try {
      await _apiClient.delete(ApiEndpoints.deleteTrip(tripId));
    } on DioException catch (e) {
      throw e.message ?? 'Failed to delete trip';
    } catch (e) {
      throw 'Failed to delete trip: $e';
    }
  }

  /// Get dashboard overview
  Future<Map<String, dynamic>> getDashboardOverview() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboardOverview);
      return response.data;
    } on DioException catch (e) {
      throw e.message ?? 'Failed to load dashboard';
    } catch (e) {
      throw 'Failed to load dashboard: $e';
    }
  }

  /// Search cities
  Future<List<CityModel>> searchCities(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.citySearch,
        queryParameters: {'q': query},
      );

      final citiesData = response.data['cities'] ?? response.data;
      if (citiesData is List) {
        return citiesData.map((city) => CityModel.fromJson(city)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw e.message ?? 'Failed to search cities';
    } catch (e) {
      throw 'Failed to search cities: $e';
    }
  }
}
