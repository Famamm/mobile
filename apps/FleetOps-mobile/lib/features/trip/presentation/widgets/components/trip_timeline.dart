import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:core/core.dart';

class TripStop {
  final String location;
  final String time;
  final String description;
  final TripStopType type;

  TripStop({
    required this.location,
    required this.time,
    required this.description,
    required this.type,
  });
}

enum TripStopType { start, stop, end }

class TripTimeline extends StatelessWidget {
  final List<TripStop> stops;

  const TripTimeline({Key? key, required this.stops}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        stops.length,
        (index) =>
            _buildTimelineItem(context, stops[index], index, stops.length),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TripStop stop,
    int index,
    int totalItems,
  ) {
    final isLast = index == totalItems - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // Marker
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getMarkerColor(stop.type),
                border: Border.all(
                  color: _getMarkerBorderColor(stop.type),
                  width: 3,
                ),
              ),
              child: Center(
                child: Icon(
                  _getMarkerIcon(stop.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            if (!isLast)
              Container(width: 3, height: 70, color: AppColors.grey300),
          ],
        ),
        const Gap(16),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  stop.time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey500,
                  ),
                ),
                const Gap(4),
                Text(
                  stop.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isLast) const Gap(20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getMarkerColor(TripStopType type) {
    switch (type) {
      case TripStopType.start:
        return AppColors.primary;
      case TripStopType.stop:
        return Colors.white;
      case TripStopType.end:
        return AppColors.error;
    }
  }

  Color _getMarkerBorderColor(TripStopType type) {
    switch (type) {
      case TripStopType.start:
        return AppColors.primary;
      case TripStopType.stop:
        return AppColors.grey300;
      case TripStopType.end:
        return AppColors.error;
    }
  }

  IconData _getMarkerIcon(TripStopType type) {
    switch (type) {
      case TripStopType.start:
        return Icons.location_on;
      case TripStopType.stop:
        return Icons.local_gas_station;
      case TripStopType.end:
        return Icons.location_on;
    }
  }
}
