/// Activity model
class ActivityModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final double? cost;
  final String? currency;
  final int? durationMinutes;
  final String? imageUrl;
  final String? location;
  final double? rating;

  ActivityModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.cost,
    this.currency,
    this.durationMinutes,
    this.imageUrl,
    this.location,
    this.rating,
  });

  String get durationFormatted {
    if (durationMinutes == null) return 'Duration not specified';
    final hours = durationMinutes! ~/ 60;
    final minutes = durationMinutes! % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  String get costFormatted {
    if (cost == null) return 'Free';
    return '${currency ?? '\$'}${cost!.toStringAsFixed(2)}';
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      category: json['category'],
      cost: json['cost']?.toDouble(),
      currency: json['currency'],
      durationMinutes: json['durationMinutes'] ?? json['duration'],
      imageUrl: json['imageUrl'] ?? json['image'],
      location: json['location'],
      rating: json['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'cost': cost,
      'currency': currency,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
      'location': location,
      'rating': rating,
    };
  }

  ActivityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? cost,
    String? currency,
    int? durationMinutes,
    String? imageUrl,
    String? location,
    double? rating,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      rating: rating ?? this.rating,
    );
  }
}
