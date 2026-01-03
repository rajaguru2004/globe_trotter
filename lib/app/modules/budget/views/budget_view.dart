import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/budget_controller.dart';
import '../../../widgets/empty_state.dart';

class BudgetView extends GetView<BudgetController> {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Budget')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final budget = controller.budget.value;
        if (budget == null) {
          return const EmptyState(
            icon: Icons.account_balance_wallet,
            message: 'No budget data available',
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Total Budget Card
            _buildTotalBudgetCard(budget, theme),
            const SizedBox(height: 16),

            // Budget Status
            _buildBudgetStatusCard(budget, theme),
            const SizedBox(height: 24),

            // Category Breakdown
            if (budget.categoryBreakdown.isNotEmpty) ...[
              Text(
                'Spending by Category',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoryPieChart(budget, theme),
              const SizedBox(height: 16),
              ...budget.categoryBreakdown.map((category) {
                return _buildCategoryItem(category, budget.actualCost, theme);
              }).toList(),
              const SizedBox(height: 24),
            ],

            // City Breakdown
            if (budget.cityBreakdown.isNotEmpty) ...[
              Text(
                'Spending by City',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...budget.cityBreakdown.map((city) {
                return _buildCityItem(city, theme);
              }).toList(),
              const SizedBox(height: 24),
            ],

            // Daily Breakdown
            if (budget.dailyBreakdown.isNotEmpty) ...[
              Text(
                'Daily Spending',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDailyBarChart(budget, theme),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildTotalBudgetCard(budget, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Budget',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${budget.totalBudget.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Spent',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${budget.actualCost.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: budget.isOverBudget
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: budget.percentageUsed / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: budget.isOverBudget
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${budget.percentageUsed.toStringAsFixed(1)}% used',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '\$${budget.remaining.abs().toStringAsFixed(2)} ${budget.isOverBudget ? 'over' : 'remaining'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: budget.isOverBudget
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetStatusCard(budget, ThemeData theme) {
    final status = budget.isOverBudget
        ? 'Over Budget'
        : budget.percentageUsed > 80
        ? 'Near Budget'
        : 'Within Budget';

    final color = budget.isOverBudget
        ? theme.colorScheme.error
        : budget.percentageUsed > 80
        ? Colors.orange
        : Colors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              budget.isOverBudget ? Icons.warning : Icons.check_circle,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    budget.isOverBudget
                        ? 'Consider adjusting your activities'
                        : 'You\'re managing your budget well',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(budget, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: budget.categoryBreakdown.map<PieChartSectionData>((
            category,
          ) {
            final percentage = (category.amount / budget.actualCost) * 100;
            return PieChartSectionData(
              value: category.amount,
              title: '${percentage.toStringAsFixed(0)}%',
              color: _getCategoryColor(category.category),
              radius: 100,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(category, double totalCost, ThemeData theme) {
    final percentage = (category.amount / totalCost) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(category.category).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(category.category),
            color: _getCategoryColor(category.category),
          ),
        ),
        title: Text(category.category),
        subtitle: Text('${category.count} activities'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${category.amount.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityItem(city, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.location_city),
        title: Text(city.cityName),
        subtitle: Text(
          '${city.days} days • Avg \$${city.averagePerDay.toStringAsFixed(2)}/day',
        ),
        trailing: Text(
          '\$${city.amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyBarChart(budget, ThemeData theme) {
    if (budget.dailyBreakdown.isEmpty) return const SizedBox();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              budget.dailyBreakdown
                  .map((d) => d.amount)
                  .reduce((a, b) => a > b ? a : b) *
              1.2,
          barGroups: budget.dailyBreakdown.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.amount,
                  color: theme.colorScheme.primary,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= budget.dailyBreakdown.length) {
                    return const SizedBox();
                  }
                  return Text(
                    'D${value.toInt() + 1}',
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'sightseeing':
        return Colors.blue;
      case 'culture':
        return Colors.purple;
      case 'entertainment':
        return Colors.pink;
      case 'adventure':
        return Colors.green;
      case 'shopping':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'sightseeing':
        return Icons.visibility;
      case 'culture':
        return Icons.museum;
      case 'entertainment':
        return Icons.theater_comedy;
      case 'adventure':
        return Icons.hiking;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
}
