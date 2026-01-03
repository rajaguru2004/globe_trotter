import 'city_model.dart';
import 'activity_model.dart';

/// Trip Stop model (represents a city in a trip with dates)
class TripStopModel {
  final String id;
  final String tripId;
  final CityModel city;
  final DateTime startDate;
  final DateTime endDate;
  final int order;
  final List<ActivityModel>? activities;
  final double? estimatedCost;

  TripStopModel({
    required this.id,
    required this.tripId,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.order,
    this.activities,
    this.estimatedCost,
  });

  int get numberOfDays {
    return endDate.difference(startDate).inDays + 1;
  }

  factory TripStopModel.fromJson(Map<String, dynamic> json) {
    return TripStopModel(
      id: json['id'] ?? json['_id'] ?? '',
      tripId: json['tripId'] ?? '',
      city: CityModel.fromJson(json['city'] ?? {}),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      order: json['order'] ?? 0,
      activities: json['activities'] != null
          ? (json['activities'] as List)
                .map((a) => ActivityModel.fromJson(a))
                .toList()
          : null,
      estimatedCost: json['estimatedCost']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'city': city.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'order': order,
      'activities': activities?.map((a) => a.toJson()).toList(),
      'estimatedCost': estimatedCost,
    };
  }
}

/// Trip status enum
enum TripStatus {
  draft,
  upcoming,
  ongoing,
  completed;

  String get displayName {
    switch (this) {
      case TripStatus.draft:
        return 'Draft';
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.ongoing:
        return 'Ongoing';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  static TripStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'draft':
        return TripStatus.draft;
      case 'upcoming':
        return TripStatus.upcoming;
      case 'ongoing':
        return TripStatus.ongoing;
      case 'completed':
        return TripStatus.completed;
      default:
        return TripStatus.draft;
    }
  }
}

/// Trip model
class TripModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final TripStatus status;
  final String? coverImage;
  final List<TripStopModel>? stops;
  final double? totalBudget;
  final double? actualCost;
  final bool isPublic;
  final String? shareSlug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TripModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.coverImage,
    this.stops,
    this.totalBudget,
    this.actualCost,
    this.isPublic = false,
    this.shareSlug,
    this.createdAt,
    this.updatedAt,
  });

  int get numberOfDays {
    return endDate.difference(startDate).inDays + 1;
  }

  int get numberOfCities {
    return stops?.length ?? 0;
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: TripStatus.fromString(json['status']),
      coverImage: json['coverImage'],
      stops: json['stops'] != null
          ? (json['stops'] as List)
                .map((s) => TripStopModel.fromJson(s))
                .toList()
          : null,
      totalBudget: json['totalBudget']?.toDouble(),
      actualCost: json['actualCost']?.toDouble(),
      isPublic: json['isPublic'] ?? false,
      shareSlug: json['shareSlug'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'coverImage': coverImage,
      'stops': stops?.map((s) => s.toJson()).toList(),
      'totalBudget': totalBudget,
      'actualCost': actualCost,
      'isPublic': isPublic,
      'shareSlug': shareSlug,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  TripModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    TripStatus? status,
    String? coverImage,
    List<TripStopModel>? stops,
    double? totalBudget,
    double? actualCost,
    bool? isPublic,
    String? shareSlug,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      coverImage: coverImage ?? this.coverImage,
      stops: stops ?? this.stops,
      totalBudget: totalBudget ?? this.totalBudget,
      actualCost: actualCost ?? this.actualCost,
      isPublic: isPublic ?? this.isPublic,
      shareSlug: shareSlug ?? this.shareSlug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
