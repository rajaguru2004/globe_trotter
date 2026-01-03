import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controllers/trips_controller.dart';
import '../../../widgets/trip_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../data/models/trip_model.dart';

class TripsView extends GetView<TripsController> {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: controller.tabController,
          children: [
            _buildTripsList(controller.upcomingTrips, 'upcoming'),
            _buildTripsList(controller.ongoingTrips, 'ongoing'),
            _buildTripsList(controller.completedTrips, 'completed'),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/create-trip'),
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }

  Widget _buildTripsList(List<TripModel> trips, String type) {
    if (trips.isEmpty) {
      String message;
      String? action;

      switch (type) {
        case 'upcoming':
          message = 'No upcoming trips yet';
          action = 'Create Trip';
          break;
        case 'ongoing':
          message = 'No ongoing trips';
          action = null;
          break;
        case 'completed':
          message = 'No completed trips';
          action = null;
          break;
        default:
          message = 'No trips found';
          action = null;
      }

      return EmptyState(
        icon: Icons.flight_takeoff,
        message: message,
        actionLabel: action,
        onActionPressed: action != null
            ? () => Get.toNamed('/create-trip')
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Slidable(
            key: ValueKey(trip.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => controller.deleteTrip(trip.id),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: TripCard(
              trip: trip,
              onTap: () => controller.goToTripDetail(trip.id),
            ),
          );
        },
      ),
    );
  }
}
