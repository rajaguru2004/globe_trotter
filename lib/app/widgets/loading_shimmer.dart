import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading shimmer widget
class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const LoadingShimmer({
    super.key,
    this.width,
    this.height = 200,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!,
      highlightColor: theme.brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Trip card shimmer
class TripCardShimmer extends StatelessWidget {
  const TripCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer(width: double.infinity, height: 150, borderRadius: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(width: 200, height: 20, borderRadius: 4),
                const SizedBox(height: 8),
                LoadingShimmer(width: 150, height: 16, borderRadius: 4),
                const SizedBox(height: 8),
                Row(
                  children: [
                    LoadingShimmer(width: 80, height: 16, borderRadius: 4),
                    const SizedBox(width: 16),
                    LoadingShimmer(width: 60, height: 16, borderRadius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// City card shimmer
class CityCardShimmer extends StatelessWidget {
  const CityCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer(width: double.infinity, height: 120, borderRadius: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(width: 100, height: 16, borderRadius: 4),
                const SizedBox(height: 4),
                LoadingShimmer(width: 60, height: 12, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
