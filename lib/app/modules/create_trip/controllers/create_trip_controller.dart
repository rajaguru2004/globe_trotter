import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/trip_model.dart';
import '../../../../core/mock/mock_trips.dart';

class CreateTripController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  /// Select start date
  Future<void> selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)), // 2 years
    );

    if (picked != null) {
      startDate.value = picked;

      // If end date is before start date, reset it
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    }
  }

  /// Select end date
  Future<void> selectEndDate(BuildContext context) async {
    final initialDate =
        endDate.value ??
        (startDate.value?.add(const Duration(days: 7)) ??
            DateTime.now().add(const Duration(days: 7)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (picked != null) {
      endDate.value = picked;
    }
  }

  /// Create trip
  Future<void> createTrip() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        'Missing Dates',
        'Please select both start and end dates',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Generate unique ID
      final uuid = const Uuid();
      final tripId = 'trip_${uuid.v4()}';

      // Create new trip
      final newTrip = TripModel(
        id: tripId,
        userId: MockTrips.getMockUserId(),
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        startDate: startDate.value!,
        endDate: endDate.value!,
        status: TripStatus.upcoming,
        coverImage: 'https://source.unsplash.com/800x600/?travel,adventure',
        stops: [], // Empty stops initially
        totalBudget: 0.0,
        actualCost: 0.0,
        isPublic: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add to mock trips
      MockTrips.addTrip(newTrip);

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Show success message
      Get.snackbar(
        'Success',
        'Trip created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to itinerary builder
      Get.offNamed('/itinerary', arguments: {'tripId': tripId});
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create trip: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate form
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a trip name';
    }
    if (value.trim().length < 3) {
      return 'Trip name must be at least 3 characters';
    }
    return null;
  }
}
