import 'package:globe_trotter_1/app/data/models/budget_model.dart';
import 'package:globe_trotter_1/app/data/models/trip_model.dart';

/// Mock budget calculation utilities
class MockBudget {
  /// Calculate budget for a trip
  static BudgetModel calculateTripBudget(TripModel trip) {
    // Calculate category breakdown
    final Map<String, double> categoryTotals = {};
    final Map<String, int> categoryCounts = {};

    // Calculate daily breakdown
    final Map<DateTime, double> dailyTotals = {};
    final Map<DateTime, int> dailyCounts = {};

    // Calculate city breakdown
    final List<BudgetCityModel> cityBreakdown = [];

    double totalActualCost = 0.0;

    // Process each stop
    if (trip.stops != null) {
      for (var stop in trip.stops!) {
        double cityTotal = 0.0;

        // Process activities in this stop
        if (stop.activities != null) {
          for (var activity in stop.activities!) {
            final cost = activity.cost ?? 0.0;
            final category = activity.category ?? 'Other';

            // Add to total
            totalActualCost += cost;
            cityTotal += cost;

            // Category breakdown
            categoryTotals[category] = (categoryTotals[category] ?? 0.0) + cost;
            categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
          }

          // Distribute city cost across days
          final days = stop.numberOfDays;
          if (days > 0) {
            final costPerDay = cityTotal / days;
            DateTime currentDate = DateTime(
              stop.startDate.year,
              stop.startDate.month,
              stop.startDate.day,
            );
            final endDate = DateTime(
              stop.endDate.year,
              stop.endDate.month,
              stop.endDate.day,
            );

            while (currentDate.isBefore(endDate) ||
                currentDate.isAtSameMomentAs(endDate)) {
              dailyTotals[currentDate] =
                  (dailyTotals[currentDate] ?? 0.0) + costPerDay;
              dailyCounts[currentDate] = (dailyCounts[currentDate] ?? 0) + 1;
              currentDate = currentDate.add(const Duration(days: 1));
            }
          }
        }

        // Add city to breakdown
        cityBreakdown.add(
          BudgetCityModel(
            cityId: stop.city.id,
            cityName: stop.city.name,
            amount: cityTotal,
            days: stop.numberOfDays,
          ),
        );
      }
    }

    // Convert maps to models
    final categoryBreakdown =
        categoryTotals.entries
            .map(
              (e) => BudgetCategoryModel(
                category: e.key,
                amount: e.value,
                count: categoryCounts[e.key] ?? 0,
              ),
            )
            .toList()
          ..sort((a, b) => b.amount.compareTo(a.amount));

    final dailyBreakdown =
        dailyTotals.entries
            .map(
              (e) => BudgetDayModel(
                date: e.key,
                amount: e.value,
                activityCount: dailyCounts[e.key] ?? 0,
                isOverBudget: false,
              ),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    return BudgetModel(
      tripId: trip.id,
      totalBudget: trip.totalBudget ?? 0.0,
      actualCost: totalActualCost,
      categoryBreakdown: categoryBreakdown,
      dailyBreakdown: dailyBreakdown,
      cityBreakdown: cityBreakdown,
    );
  }

  /// Generate mock category breakdown (for demo purposes)
  static List<BudgetCategoryModel> generateMockCategoryBreakdown() {
    return [
      BudgetCategoryModel(category: 'Food', amount: 450.00, count: 12),
      BudgetCategoryModel(category: 'Sightseeing', amount: 380.00, count: 8),
      BudgetCategoryModel(category: 'Culture', amount: 320.00, count: 6),
      BudgetCategoryModel(category: 'Entertainment', amount: 280.00, count: 5),
      BudgetCategoryModel(category: 'Adventure', amount: 220.00, count: 4),
      BudgetCategoryModel(category: 'Shopping', amount: 150.00, count: 3),
    ];
  }

  /// Generate mock daily breakdown (for demo purposes)
  static List<BudgetDayModel> generateMockDailyBreakdown(
    DateTime startDate,
    int days,
  ) {
    final List<BudgetDayModel> breakdown = [];
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final amount = 80.0 + (i % 3) * 30.0; // Varying daily costs
      breakdown.add(
        BudgetDayModel(
          date: date,
          amount: amount,
          activityCount: 2 + (i % 2),
          isOverBudget: amount > 120,
        ),
      );
    }
    return breakdown;
  }

  /// Calculate total cost from trip stops
  static double calculateTotalCost(TripModel trip) {
    double total = 0.0;
    if (trip.stops != null) {
      for (var stop in trip.stops!) {
        if (stop.activities != null) {
          for (var activity in stop.activities!) {
            total += activity.cost ?? 0.0;
          }
        }
      }
    }
    return total;
  }

  /// Calculate average cost per day
  static double calculateAverageCostPerDay(TripModel trip) {
    final totalCost = calculateTotalCost(trip);
    final days = trip.numberOfDays;
    return days > 0 ? totalCost / days : 0.0;
  }

  /// Get budget status
  static String getBudgetStatus(BudgetModel budget) {
    if (budget.isOverBudget) {
      return 'Over Budget';
    } else if (budget.percentageUsed > 80) {
      return 'Near Budget';
    } else {
      return 'Within Budget';
    }
  }

  /// Get budget color
  static String getBudgetColor(BudgetModel budget) {
    if (budget.isOverBudget) {
      return '#F44336'; // Red
    } else if (budget.percentageUsed > 80) {
      return '#FF9800'; // Orange
    } else {
      return '#4CAF50'; // Green
    }
  }
}
