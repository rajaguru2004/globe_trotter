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

        return controller.isTimelineView.value
            ? _buildTimelineView(sortedDays, activitiesByDay, theme)
            : _buildCalendarView(sortedDays, activitiesByDay, theme);
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
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
}
