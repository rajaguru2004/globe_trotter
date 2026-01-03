import 'package:globe_trotter_1/app/data/models/activity_model.dart';

/// Mock data for activities by city
class MockActivities {
  static final Map<String, List<ActivityModel>> activitiesByCity = {
    // Paris activities
    'city_1': [
      ActivityModel(
        id: 'act_paris_1',
        name: 'Eiffel Tower Visit',
        description: 'Visit the iconic Eiffel Tower and enjoy panoramic views',
        category: 'Sightseeing',
        cost: 26.00,
        currency: '€',
        durationMinutes: 180,
        imageUrl:
            'https://images.pexels.com/photos/338515/pexels-photo-338515.jpeg',
        location: 'Champ de Mars, Paris',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_paris_2',
        name: 'Louvre Museum',
        description: 'Explore the world\'s largest art museum',
        category: 'Culture',
        cost: 17.00,
        currency: '€',
        durationMinutes: 240,
        imageUrl:
            'https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg',
        location: 'Louvre, Paris',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_paris_3',
        name: 'Seine River Cruise',
        description: 'Romantic boat ride along the Seine',
        category: 'Entertainment',
        cost: 35.00,
        currency: '€',
        durationMinutes: 120,
        imageUrl:
            'https://images.pexels.com/photos/338515/pexels-photo-338515.jpeg',
        location: 'Seine River, Paris',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_paris_4',
        name: 'French Bistro Lunch',
        description: 'Authentic French cuisine experience',
        category: 'Food',
        cost: 45.00,
        currency: '€',
        durationMinutes: 90,
        imageUrl:
            'https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg',
        location: 'Le Marais, Paris',
        rating: 4.6,
      ),
      ActivityModel(
        id: 'act_paris_5',
        name: 'Montmartre Walking Tour',
        description: 'Discover the artistic heart of Paris',
        category: 'Sightseeing',
        cost: 20.00,
        currency: '€',
        durationMinutes: 150,
        imageUrl:
            'https://images.pexels.com/photos/338515/pexels-photo-338515.jpeg',
        location: 'Montmartre, Paris',
        rating: 4.5,
      ),
    ],

    // Tokyo activities
    'city_2': [
      ActivityModel(
        id: 'act_tokyo_1',
        name: 'Senso-ji Temple',
        description: 'Visit Tokyo\'s oldest temple',
        category: 'Culture',
        cost: 0.00,
        currency: '¥',
        durationMinutes: 120,
        imageUrl:
            'https://images.pexels.com/photos/590478/pexels-photo-590478.jpeg',
        location: 'Asakusa, Tokyo',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_tokyo_2',
        name: 'Sushi Making Class',
        description: 'Learn to make authentic sushi',
        category: 'Food',
        cost: 8500.00,
        currency: '¥',
        durationMinutes: 180,
        imageUrl:
            'https://images.pexels.com/photos/590478/pexels-photo-590478.jpeg',
        location: 'Shibuya, Tokyo',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_tokyo_3',
        name: 'Tokyo Skytree',
        description: 'Panoramic views from the tallest structure',
        category: 'Sightseeing',
        cost: 3100.00,
        currency: '¥',
        durationMinutes: 150,
        imageUrl:
            'https://images.pexels.com/photos/590478/pexels-photo-590478.jpeg',
        location: 'Sumida, Tokyo',
        rating: 4.6,
      ),
      ActivityModel(
        id: 'act_tokyo_4',
        name: 'Akihabara Electronics District',
        description: 'Explore the tech and anime capital',
        category: 'Shopping',
        cost: 0.00,
        currency: '¥',
        durationMinutes: 180,
        imageUrl: 'https://source.unsplash.com/600x400/?akihabara,tokyo',
        location: 'Akihabara, Tokyo',
        rating: 4.4,
      ),
      ActivityModel(
        id: 'act_tokyo_5',
        name: 'Tsukiji Fish Market',
        description: 'Fresh seafood and street food',
        category: 'Food',
        cost: 2000.00,
        currency: '¥',
        durationMinutes: 120,
        imageUrl: 'https://source.unsplash.com/600x400/?tsukiji,market',
        location: 'Tsukiji, Tokyo',
        rating: 4.7,
      ),
    ],

    // New York activities
    'city_3': [
      ActivityModel(
        id: 'act_ny_1',
        name: 'Statue of Liberty Tour',
        description: 'Ferry ride to the iconic statue',
        category: 'Sightseeing',
        cost: 24.00,
        currency: '\$',
        durationMinutes: 240,
        imageUrl:
            'https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg',
        location: 'Liberty Island, NY',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_ny_2',
        name: 'Central Park Bike Tour',
        description: 'Bike through the urban oasis',
        category: 'Adventure',
        cost: 45.00,
        currency: '\$',
        durationMinutes: 180,
        imageUrl:
            'https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg',
        location: 'Central Park, NY',
        rating: 4.6,
      ),
      ActivityModel(
        id: 'act_ny_3',
        name: 'Broadway Show',
        description: 'World-class theater performance',
        category: 'Entertainment',
        cost: 150.00,
        currency: '\$',
        durationMinutes: 180,
        imageUrl:
            'https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg',
        location: 'Times Square, NY',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_ny_4',
        name: 'MoMA Visit',
        description: 'Museum of Modern Art exploration',
        category: 'Culture',
        cost: 25.00,
        currency: '\$',
        durationMinutes: 180,
        imageUrl: 'https://source.unsplash.com/600x400/?moma,art',
        location: 'Midtown Manhattan, NY',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_ny_5',
        name: 'New York Pizza Tour',
        description: 'Best pizza slices in the city',
        category: 'Food',
        cost: 55.00,
        currency: '\$',
        durationMinutes: 150,
        imageUrl: 'https://source.unsplash.com/600x400/?new-york,pizza',
        location: 'Brooklyn, NY',
        rating: 4.5,
      ),
    ],

    // Rome activities
    'city_4': [
      ActivityModel(
        id: 'act_rome_1',
        name: 'Colosseum & Forum',
        description: 'Ancient Roman landmarks tour',
        category: 'Culture',
        cost: 35.00,
        currency: '€',
        durationMinutes: 240,
        imageUrl:
            'https://images.pexels.com/photos/753639/pexels-photo-753639.jpeg',
        location: 'Rome, Italy',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_rome_2',
        name: 'Vatican Museums',
        description: 'Sistine Chapel and Vatican treasures',
        category: 'Culture',
        cost: 30.00,
        currency: '€',
        durationMinutes: 240,
        imageUrl:
            'https://images.pexels.com/photos/753639/pexels-photo-753639.jpeg',
        location: 'Vatican City',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_rome_3',
        name: 'Pasta Making Class',
        description: 'Learn authentic Italian pasta',
        category: 'Food',
        cost: 65.00,
        currency: '€',
        durationMinutes: 180,
        imageUrl: 'https://source.unsplash.com/600x400/?pasta,cooking',
        location: 'Trastevere, Rome',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_rome_4',
        name: 'Trevi Fountain & Gelato',
        description: 'Toss a coin and enjoy gelato',
        category: 'Sightseeing',
        cost: 15.00,
        currency: '€',
        durationMinutes: 60,
        imageUrl: 'https://source.unsplash.com/600x400/?trevi-fountain',
        location: 'Rome, Italy',
        rating: 4.6,
      ),
      ActivityModel(
        id: 'act_rome_5',
        name: 'Roman Food Market Tour',
        description: 'Explore local markets and taste specialties',
        category: 'Food',
        cost: 45.00,
        currency: '€',
        durationMinutes: 180,
        imageUrl: 'https://source.unsplash.com/600x400/?italian,market',
        location: 'Campo de\' Fiori, Rome',
        rating: 4.5,
      ),
    ],

    // London activities
    'city_5': [
      ActivityModel(
        id: 'act_london_1',
        name: 'Tower of London',
        description: 'Historic castle and Crown Jewels',
        category: 'Culture',
        cost: 29.00,
        currency: '£',
        durationMinutes: 180,
        imageUrl:
            'https://images.pexels.com/photos/672532/pexels-photo-672532.jpeg',
        location: 'Tower Hill, London',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_london_2',
        name: 'British Museum',
        description: 'World history and culture museum',
        category: 'Culture',
        cost: 0.00,
        currency: '£',
        durationMinutes: 240,
        imageUrl:
            'https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg',
        location: 'Bloomsbury, London',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_london_3',
        name: 'Thames River Cruise',
        description: 'Scenic cruise with city views',
        category: 'Entertainment',
        cost: 25.00,
        currency: '£',
        durationMinutes: 120,
        imageUrl:
            'https://images.pexels.com/photos/672532/pexels-photo-672532.jpeg',
        location: 'Thames River, London',
        rating: 4.5,
      ),
      ActivityModel(
        id: 'act_london_4',
        name: 'Afternoon Tea',
        description: 'Traditional British tea experience',
        category: 'Food',
        cost: 55.00,
        currency: '£',
        durationMinutes: 120,
        imageUrl: 'https://source.unsplash.com/600x400/?afternoon-tea',
        location: 'Mayfair, London',
        rating: 4.6,
      ),
      ActivityModel(
        id: 'act_london_5',
        name: 'London Eye',
        description: 'Giant observation wheel',
        category: 'Sightseeing',
        cost: 27.00,
        currency: '£',
        durationMinutes: 45,
        imageUrl: 'https://source.unsplash.com/600x400/?london-eye',
        location: 'South Bank, London',
        rating: 4.4,
      ),
    ],

    // Barcelona activities
    'city_6': [
      ActivityModel(
        id: 'act_bcn_1',
        name: 'Sagrada Familia',
        description: 'Gaudí\'s masterpiece basilica',
        category: 'Culture',
        cost: 26.00,
        currency: '€',
        durationMinutes: 150,
        imageUrl:
            'https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg',
        location: 'Barcelona, Spain',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_bcn_2',
        name: 'Park Güell',
        description: 'Colorful mosaic park by Gaudí',
        category: 'Sightseeing',
        cost: 10.00,
        currency: '€',
        durationMinutes: 120,
        imageUrl:
            'https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg',
        location: 'Barcelona, Spain',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_bcn_3',
        name: 'Tapas Tour',
        description: 'Sample authentic Spanish tapas',
        category: 'Food',
        cost: 50.00,
        currency: '€',
        durationMinutes: 180,
        imageUrl: 'https://source.unsplash.com/600x400/?spanish,tapas',
        location: 'Gothic Quarter, Barcelona',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_bcn_4',
        name: 'Beach Day at Barceloneta',
        description: 'Relax on the Mediterranean coast',
        category: 'Adventure',
        cost: 0.00,
        currency: '€',
        durationMinutes: 240,
        imageUrl:
            'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg',
        location: 'Barceloneta, Barcelona',
        rating: 4.5,
      ),
      ActivityModel(
        id: 'act_bcn_5',
        name: 'Flamenco Show',
        description: 'Traditional Spanish dance performance',
        category: 'Entertainment',
        cost: 40.00,
        currency: '€',
        durationMinutes: 120,
        imageUrl: 'https://source.unsplash.com/600x400/?flamenco,dance',
        location: 'Barcelona, Spain',
        rating: 4.6,
      ),
    ],

    // Dubai activities
    'city_7': [
      ActivityModel(
        id: 'act_dubai_1',
        name: 'Burj Khalifa',
        description: 'World\'s tallest building observation deck',
        category: 'Sightseeing',
        cost: 140.00,
        currency: 'AED',
        durationMinutes: 120,
        imageUrl:
            'https://images.pexels.com/photos/2044434/pexels-photo-2044434.jpeg',
        location: 'Downtown Dubai',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_dubai_2',
        name: 'Desert Safari',
        description: 'Dune bashing and Bedouin camp',
        category: 'Adventure',
        cost: 250.00,
        currency: 'AED',
        durationMinutes: 360,
        imageUrl:
            'https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg',
        location: 'Dubai Desert',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_dubai_3',
        name: 'Gold Souk Shopping',
        description: 'Traditional gold market',
        category: 'Shopping',
        cost: 0.00,
        currency: 'AED',
        durationMinutes: 120,
        imageUrl: 'https://source.unsplash.com/600x400/?gold,souk',
        location: 'Deira, Dubai',
        rating: 4.5,
      ),
      ActivityModel(
        id: 'act_dubai_4',
        name: 'Dubai Marina Yacht Cruise',
        description: 'Luxury yacht experience',
        category: 'Entertainment',
        cost: 350.00,
        currency: 'AED',
        durationMinutes: 180,
        imageUrl:
            'https://images.pexels.com/photos/2044434/pexels-photo-2044434.jpeg',
        location: 'Dubai Marina',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_dubai_5',
        name: 'Traditional Emirati Meal',
        description: 'Authentic Middle Eastern cuisine',
        category: 'Food',
        cost: 180.00,
        currency: 'AED',
        durationMinutes: 120,
        imageUrl: 'https://source.unsplash.com/600x400/?emirati,food',
        location: 'Al Fahidi, Dubai',
        rating: 4.6,
      ),
    ],

    // Sydney activities
    'city_8': [
      ActivityModel(
        id: 'act_syd_1',
        name: 'Sydney Opera House Tour',
        description: 'Iconic architectural masterpiece',
        category: 'Culture',
        cost: 42.00,
        currency: 'A\$',
        durationMinutes: 90,
        imageUrl: 'https://source.unsplash.com/600x400/?sydney,opera',
        location: 'Sydney Harbour',
        rating: 4.8,
      ),
      ActivityModel(
        id: 'act_syd_2',
        name: 'Bondi Beach & Coastal Walk',
        description: 'Famous beach and scenic cliffs',
        category: 'Adventure',
        cost: 0.00,
        currency: 'A\$',
        durationMinutes: 240,
        imageUrl: 'https://source.unsplash.com/600x400/?bondi,beach',
        location: 'Bondi, Sydney',
        rating: 4.7,
      ),
      ActivityModel(
        id: 'act_syd_3',
        name: 'Harbour Bridge Climb',
        description: 'Climb the iconic bridge',
        category: 'Adventure',
        cost: 268.00,
        currency: 'A\$',
        durationMinutes: 210,
        imageUrl: 'https://source.unsplash.com/600x400/?harbour-bridge',
        location: 'Sydney Harbour',
        rating: 4.9,
      ),
      ActivityModel(
        id: 'act_syd_4',
        name: 'Taronga Zoo',
        description: 'Australian wildlife with harbour views',
        category: 'Sightseeing',
        cost: 49.00,
        currency: 'A\$',
        durationMinutes: 240,
        imageUrl: 'https://source.unsplash.com/600x400/?taronga,zoo',
        location: 'Mosman, Sydney',
        rating: 4.6,
      ),
      ActivityModel(
        id: 'act_syd_5',
        name: 'Fish Market Food Tour',
        description: 'Fresh seafood tasting',
        category: 'Food',
        cost: 75.00,
        currency: 'A\$',
        durationMinutes: 150,
        imageUrl: 'https://source.unsplash.com/600x400/?fish,market',
        location: 'Pyrmont, Sydney',
        rating: 4.5,
      ),
    ],
  };

  /// Get activities for a city
  static List<ActivityModel> getActivitiesForCity(String cityId) {
    return activitiesByCity[cityId] ?? [];
  }

  /// Get all activities
  static List<ActivityModel> getAllActivities() {
    return activitiesByCity.values.expand((list) => list).toList();
  }

  /// Get activity by ID
  static ActivityModel? getActivityById(String activityId) {
    for (var activities in activitiesByCity.values) {
      try {
        return activities.firstWhere((a) => a.id == activityId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }
}
