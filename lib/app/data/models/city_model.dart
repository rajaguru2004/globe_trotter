/// City model
class CityModel {
  final String id;
  final String name;
  final String country;
  final String? description;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final String? currency;

  CityModel({
    required this.id,
    required this.name,
    required this.country,
    this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.timezone,
    this.currency,
  });

  String get displayName => '$name, $country';

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      timezone: json['timezone'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'currency': currency,
    };
  }

  CityModel copyWith({
    String? id,
    String? name,
    String? country,
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? timezone,
    String? currency,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
    );
  }
}
