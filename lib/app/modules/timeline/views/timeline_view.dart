import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/timeline_controller.dart';
import '../../../widgets/activity_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../data/models/activity_model.dart';

class TimelineView extends GetView<TimelineController> {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        actions: [
          Obx(
            () => SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Timeline'),
                  icon: Icon(Icons.timeline),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Calendar'),
                  icon: Icon(Icons.calendar_month),
                ),
              ],
              selected: {controller.isTimelineView.value},
              onSelectionChanged: (Set<bool> selection) {
                controller.toggleView();
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8),
                ),
                textStyle: WidgetStateProperty.all(theme.textTheme.labelSmall),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final trip = controller.trip.value;
        if (trip == null || trip.stops == null || trip.stops!.isEmpty) {
          return const EmptyState(
            icon: Icons.event_busy,
            message: 'No timeline data available',
          );
        }

        final activitiesByDay = controller.getActivitiesByDay();
        final sortedDays = activitiesByDay.keys.toList()..sort();
        final conflictData = controller.detectConflicts();

        return Column(
          children: [
            // Conflict Alert Banner
            if (conflictData['hasConflicts'])
              _buildConflictAlert(conflictData, theme, context),

            // Timeline or Calendar View
            Expanded(
              child: controller.isTimelineView.value
                  ? _buildTimelineView(sortedDays, activitiesByDay, theme)
                  : _buildCalendarView(sortedDays, activitiesByDay, theme),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTimelineView(
    List<DateTime> days,
    Map<DateTime, List<dynamic>> activitiesByDay,
    ThemeData theme,
  ) {
    final dateFormat = DateFormat('EEEE, MMM dd');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final items = activitiesByDay[day] ?? [];
        final dayNumber = index + 1;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: controller.isDayProblematic(day)
                        ? Colors.orange
                        : theme.colorScheme.primary,
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (controller.isDayProblematic(day))
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                dateFormat.format(day),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${items.where((i) => i['type'] == 'activity').length} activities',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: items.map((item) {
                      if (item['type'] == 'city') {
                        final city = item['data'];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city.name,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      city.country,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ActivityCard(
                          activity: item['data'] as ActivityModel,
                        );
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView(
    List<DateTime> days,
    Map<DateTime, List<dynamic>> activitiesByDay,
    ThemeData theme,
  ) {
    final dateFormat = DateFormat('EEE, MMM dd');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final items = activitiesByDay[day] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    dateFormat.format(day),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Activities
            ...items.map((item) {
              if (item['type'] == 'city') {
                final city = item['data'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flight_takeoff,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Arrive in ${city.name}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ActivityCard(activity: item['data'] as ActivityModel);
              }
            }).toList(),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildConflictAlert(
    Map<String, dynamic> conflictData,
    ThemeData theme,
    BuildContext context,
  ) {
    final conflicts = conflictData['conflicts'] as List<String>;
    final severity = conflictData['severity'] as String;
    final suggestions = controller.getConflictSuggestions();

    // Determine gradient based on severity
    final gradient = severity == 'critical'
        ? const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFD63031)])
        : const LinearGradient(colors: [Color(0xFFFFA502), Color(0xFFFF7F00)]);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule Conflict Detected!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${conflicts.length} potential issue${conflicts.length > 1 ? 's' : ''} found',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Conflicts List
          ...conflicts
              .map(
                (conflict) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          conflict,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),

          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),

          // Suggestions
          Text(
            'Suggestions:',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...suggestions
              .map(
                (suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggestion,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),

          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showInteractiveTimeline(context, conflictData, theme);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: gradient.colors.first,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Adjust Trip Plan',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: gradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInteractiveTimeline(
    BuildContext context,
    Map<String, dynamic> conflictData,
    ThemeData theme,
  ) {
    final trip = controller.trip.value;
    if (trip == null) return;

    final problematicDays = conflictData['problematicDays'] as List<DateTime>;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Timeline',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap on red markers to see conflict details',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildLegendItem(Icons.circle, Colors.red, 'Conflict', theme),
                  const SizedBox(width: 20),
                  _buildLegendItem(
                    Icons.circle,
                    Colors.green,
                    'Available',
                    theme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Visual Timeline
            Expanded(
              child: _buildVisualTimeline(
                trip,
                problematicDays,
                theme,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    IconData icon,
    Color color,
    String label,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildVisualTimeline(
    trip,
    List<DateTime> problematicDays,
    ThemeData theme,
    BuildContext context,
  ) {
    final startDate = trip.startDate;
    final endDate = trip.endDate;
    final totalDays = endDate.difference(startDate).inDays + 1;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(totalDays, (index) {
          final currentDate = startDate.add(Duration(days: index));
          final isProblematic = problematicDays.any(
            (d) =>
                d.year == currentDate.year &&
                d.month == currentDate.month &&
                d.day == currentDate.day,
          );
          final isWeekday =
              currentDate.weekday >= 1 && currentDate.weekday <= 5;

          return _buildTimelineDate(
            currentDate,
            isProblematic,
            isWeekday,
            index + 1,
            theme,
            context,
          );
        }),
      ),
    );
  }

  Widget _buildTimelineDate(
    DateTime date,
    bool isProblematic,
    bool isWeekday,
    int dayNumber,
    ThemeData theme,
    BuildContext context,
  ) {
    final dateFormat = DateFormat('MMM\ndd');

    return GestureDetector(
      onTap: isProblematic
          ? () => _showConflictDetails(date, isWeekday, context, theme)
          : null,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            // Day Number Badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isProblematic
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isProblematic ? Colors.red : Colors.green,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'Day\n$dayNumber',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isProblematic ? Colors.red : Colors.green,
                    ),
                  ),
                  if (isProblematic)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning,
                          size: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Date
            Text(
              dateFormat.format(date),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isProblematic ? Colors.red : Colors.grey[700],
                fontWeight: isProblematic ? FontWeight.bold : FontWeight.normal,
              ),
            ),

            const SizedBox(height: 4),

            // Weekday indicator
            if (isWeekday)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Weekday',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Colors.orange[800],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showConflictDetails(
    DateTime date,
    bool isWeekday,
    BuildContext context,
    ThemeData theme,
  ) {
    final activitiesByDay = controller.getActivitiesByDay();
    final dayActivities = activitiesByDay[date] ?? [];
    final activityCount = dayActivities
        .where((i) => i['type'] == 'activity')
        .length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Conflict on ${DateFormat('MMM dd').format(date)}',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWeekday)
              _buildConflictDetail(
                Icons.work,
                'Work Day',
                'This is a ${DateFormat('EEEE').format(date)} - may conflict with work schedule',
                theme,
              ),
            if (activityCount > 4)
              _buildConflictDetail(
                Icons.schedule,
                'Overbooked',
                '$activityCount activities planned - schedule may be too tight',
                theme,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.back();
              Get.snackbar(
                'Navigate to Itinerary',
                'Modify activities for ${DateFormat('MMM dd').format(date)}',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Adjust'),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictDetail(
    IconData icon,
    String title,
    String description,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
