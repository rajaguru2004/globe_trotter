/// Budget breakdown model
class BudgetModel {
  final String tripId;
  final double totalBudget;
  final double actualCost;
  final List<BudgetCategoryModel> categoryBreakdown;
  final List<BudgetDayModel> dailyBreakdown;
  final List<BudgetCityModel> cityBreakdown;

  BudgetModel({
    required this.tripId,
    required this.totalBudget,
    required this.actualCost,
    required this.categoryBreakdown,
    required this.dailyBreakdown,
    required this.cityBreakdown,
  });

  double get remaining {
    return totalBudget - actualCost;
  }

  bool get isOverBudget {
    return actualCost > totalBudget;
  }

  double get percentageUsed {
    if (totalBudget == 0) return 0;
    return (actualCost / totalBudget) * 100;
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      tripId: json['tripId'] ?? '',
      totalBudget: (json['totalBudget'] ?? 0).toDouble(),
      actualCost: (json['actualCost'] ?? 0).toDouble(),
      categoryBreakdown: json['categoryBreakdown'] != null
          ? (json['categoryBreakdown'] as List)
                .map((c) => BudgetCategoryModel.fromJson(c))
                .toList()
          : [],
      dailyBreakdown: json['dailyBreakdown'] != null
          ? (json['dailyBreakdown'] as List)
                .map((d) => BudgetDayModel.fromJson(d))
                .toList()
          : [],
      cityBreakdown: json['cityBreakdown'] != null
          ? (json['cityBreakdown'] as List)
                .map((c) => BudgetCityModel.fromJson(c))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'totalBudget': totalBudget,
      'actualCost': actualCost,
      'categoryBreakdown': categoryBreakdown.map((c) => c.toJson()).toList(),
      'dailyBreakdown': dailyBreakdown.map((d) => d.toJson()).toList(),
      'cityBreakdown': cityBreakdown.map((c) => c.toJson()).toList(),
    };
  }
}

/// Budget category breakdown
class BudgetCategoryModel {
  final String category;
  final double amount;
  final int count;

  BudgetCategoryModel({
    required this.category,
    required this.amount,
    required this.count,
  });

  factory BudgetCategoryModel.fromJson(Map<String, dynamic> json) {
    return BudgetCategoryModel(
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'category': category, 'amount': amount, 'count': count};
  }
}

/// Budget daily breakdown
class BudgetDayModel {
  final DateTime date;
  final double amount;
  final int activityCount;
  final bool isOverBudget;

  BudgetDayModel({
    required this.date,
    required this.amount,
    required this.activityCount,
    this.isOverBudget = false,
  });

  factory BudgetDayModel.fromJson(Map<String, dynamic> json) {
    return BudgetDayModel(
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0).toDouble(),
      activityCount: json['activityCount'] ?? 0,
      isOverBudget: json['isOverBudget'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'activityCount': activityCount,
      'isOverBudget': isOverBudget,
    };
  }
}

/// Budget city breakdown
class BudgetCityModel {
  final String cityId;
  final String cityName;
  final double amount;
  final int days;

  BudgetCityModel({
    required this.cityId,
    required this.cityName,
    required this.amount,
    required this.days,
  });

  double get averagePerDay {
    return days > 0 ? amount / days : 0;
  }

  factory BudgetCityModel.fromJson(Map<String, dynamic> json) {
    return BudgetCityModel(
      cityId: json['cityId'] ?? '',
      cityName: json['cityName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      days: json['days'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'cityName': cityName,
      'amount': amount,
      'days': days,
    };
  }
}
