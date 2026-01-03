import 'package:get/get.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/budget_model.dart';
import '../../../../core/mock/mock_trips.dart';
import '../../../../core/mock/mock_budget.dart';

class BudgetController extends GetxController {
  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final Rx<BudgetModel?> budget = Rx<BudgetModel?>(null);
  final RxBool isLoading = false.obs;

  String? tripId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    tripId = args?['tripId'];

    if (tripId != null) {
      loadBudget();
    }
  }

  /// Load budget data
  Future<void> loadBudget() async {
    try {
      isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      trip.value = MockTrips.getTripById(tripId!);

      if (trip.value != null) {
        budget.value = MockBudget.calculateTripBudget(trip.value!);
      }
    } catch (e) {
      print('Load budget error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
