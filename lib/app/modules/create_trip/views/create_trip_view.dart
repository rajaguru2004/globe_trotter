import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/create_trip_controller.dart';

class CreateTripView extends GetView<CreateTripController> {
  const CreateTripView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Trip')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Trip Name
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Trip Name',
                hintText: 'e.g., European Adventure',
                prefixIcon: const Icon(Icons.flight_takeoff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.words,
              validator: controller.validateName,
            ),
            const SizedBox(height: 16),

            // Start Date
            Obx(
              () => InkWell(
                onTap: () => controller.selectStartDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.startDate.value != null
                            ? dateFormat.format(controller.startDate.value!)
                            : 'Select start date',
                        style: controller.startDate.value != null
                            ? theme.textTheme.bodyLarge
                            : theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // End Date
            Obx(
              () => InkWell(
                onTap: () => controller.selectEndDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    prefixIcon: const Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.endDate.value != null
                            ? dateFormat.format(controller.endDate.value!)
                            : 'Select end date',
                        style: controller.endDate.value != null
                            ? theme.textTheme.bodyLarge
                            : theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: controller.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Describe your trip...',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Create Button
            Obx(
              () => FilledButton.icon(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.createTrip,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  controller.isLoading.value ? 'Creating...' : 'Create Trip',
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
