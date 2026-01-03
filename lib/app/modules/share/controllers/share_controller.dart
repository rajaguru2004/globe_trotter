import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/trip_model.dart';
import '../../../../core/mock/mock_trips.dart';

class ShareController extends GetxController {
  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final RxBool isLoading = false.obs;

  String? tripId;
  String? shareUrl;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    tripId = args?['tripId'];

    if (tripId != null) {
      loadTrip();
    }
  }

  /// Load trip data
  Future<void> loadTrip() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 300));

      trip.value = MockTrips.getTripById(tripId!);

      // Generate share URL (mock)
      if (trip.value != null) {
        shareUrl =
            'https://globetrotter.app/trip/${trip.value!.shareSlug ?? tripId}';
      }
    } catch (e) {
      print('Load trip error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Copy share link
  Future<void> copyShareLink() async {
    if (shareUrl != null) {
      await Clipboard.setData(ClipboardData(text: shareUrl!));
      Get.snackbar(
        'Link Copied',
        'Share link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }
}
