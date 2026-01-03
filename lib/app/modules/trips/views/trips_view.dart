import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controllers/trips_controller.dart';
import '../../../widgets/trip_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../data/models/trip_model.dart';

/// Premium My Trips screen
class TripsView extends GetView<TripsController> {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Premium App Bar
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF667EEA),
                        const Color(0xFF764BA2),
                        const Color(0xFFF093FB),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'My Trips',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'All your adventures in one place',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: controller.tabController,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: const Color(0xFF667EEA),
                  unselectedLabelColor: const Color(0xFF636E72),
                  indicatorColor: const Color(0xFF667EEA),
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
            ),
          ];
        },
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/create-trip'),
        backgroundColor: const Color(0xFF667EEA),
        elevation: 8,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'New Trip',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
      color: const Color(0xFF667EEA),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Slidable(
            key: ValueKey(trip.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (_) => _showDeleteDialog(trip),
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  borderRadius: BorderRadius.circular(20),
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

  void _showDeleteDialog(TripModel trip) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 32,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Trip?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${trip.name}"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: const Color(0xFF636E72).withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.deleteTrip(trip.id);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: const Color(0xFFF8F9FA), child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
