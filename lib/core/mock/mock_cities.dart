import 'package:globe_trotter_1/app/data/models/city_model.dart';

/// Mock data for popular cities
class MockCities {
  static final List<CityModel> popularCities = [
    CityModel(
      id: 'city_1',
      name: 'Paris',
      country: 'France',
      description: 'The City of Light, known for its art, fashion, and culture',
      imageUrl:
          'https://images.pexels.com/photos/338515/pexels-photo-338515.jpeg',
      latitude: 48.8566,
      longitude: 2.3522,
      timezone: 'Europe/Paris',
      currency: 'EUR',
    ),
    CityModel(
      id: 'city_2',
      name: 'Tokyo',
      country: 'Japan',
      description: 'A bustling metropolis blending tradition and modernity',
      imageUrl:
          'https://images.pexels.com/photos/590478/pexels-photo-590478.jpeg',
      latitude: 35.6762,
      longitude: 139.6503,
      timezone: 'Asia/Tokyo',
      currency: 'JPY',
    ),
    CityModel(
      id: 'city_3',
      name: 'New York',
      country: 'USA',
      description:
          'The city that never sleeps, a global hub of culture and commerce',
      imageUrl:
          'https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg',
      latitude: 40.7128,
      longitude: -74.0060,
      timezone: 'America/New_York',
      currency: 'USD',
    ),
    CityModel(
      id: 'city_4',
      name: 'Rome',
      country: 'Italy',
      description: 'The Eternal City, rich in history and ancient architecture',
      imageUrl:
          'https://images.pexels.com/photos/753639/pexels-photo-753639.jpeg',
      latitude: 41.9028,
      longitude: 12.4964,
      timezone: 'Europe/Rome',
      currency: 'EUR',
    ),
    CityModel(
      id: 'city_5',
      name: 'London',
      country: 'United Kingdom',
      description: 'A historic city with royal palaces and modern attractions',
      imageUrl:
          'https://images.pexels.com/photos/672532/pexels-photo-672532.jpeg',
      latitude: 51.5074,
      longitude: -0.1278,
      timezone: 'Europe/London',
      currency: 'GBP',
    ),
    CityModel(
      id: 'city_6',
      name: 'Barcelona',
      country: 'Spain',
      description: 'A vibrant coastal city known for Gaudí\'s architecture',
      imageUrl:
          'https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg',
      latitude: 41.3851,
      longitude: 2.1734,
      timezone: 'Europe/Madrid',
      currency: 'EUR',
    ),
    CityModel(
      id: 'city_7',
      name: 'Dubai',
      country: 'UAE',
      description: 'A futuristic city of luxury and innovation',
      imageUrl:
          'https://images.pexels.com/photos/2044434/pexels-photo-2044434.jpeg',
      latitude: 25.2048,
      longitude: 55.2708,
      timezone: 'Asia/Dubai',
      currency: 'AED',
    ),
    CityModel(
      id: 'city_8',
      name: 'Sydney',
      country: 'Australia',
      description: 'A stunning harbor city with iconic landmarks',
      imageUrl:
          'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg',
      latitude: -33.8688,
      longitude: 151.2093,
      timezone: 'Australia/Sydney',
      currency: 'AUD',
    ),
    CityModel(
      id: 'city_9',
      name: 'Bali',
      country: 'Indonesia',
      description: 'A tropical paradise with beaches and temples',
      imageUrl:
          'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg',
      latitude: -8.3405,
      longitude: 115.0920,
      timezone: 'Asia/Makassar',
      currency: 'IDR',
    ),
    CityModel(
      id: 'city_10',
      name: 'Reykjavik',
      country: 'Iceland',
      description: 'Gateway to natural wonders and northern lights',
      imageUrl:
          'https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg',
      latitude: 64.1466,
      longitude: -21.9426,
      timezone: 'Atlantic/Reykjavik',
      currency: 'ISK',
    ),
  ];

  /// Get city by ID
  static CityModel? getCityById(String id) {
    try {
      return popularCities.firstWhere((city) => city.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get cities by IDs
  static List<CityModel> getCitiesByIds(List<String> ids) {
    return popularCities.where((city) => ids.contains(city.id)).toList();
  }
}
