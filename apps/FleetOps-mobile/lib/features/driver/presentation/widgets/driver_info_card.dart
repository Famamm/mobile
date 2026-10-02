import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DriverInfoCards extends StatelessWidget {
  final int totalTrips;
  final String address;

  const DriverInfoCards({
    super.key,
    required this.totalTrips,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.route_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: const Text('Total Perjalanan'),
            subtitle: Text(
              totalTrips.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]},',
                  ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: const Text('Alamat'),
            subtitle: Text(
              address.isEmpty ? '-' : address,
            ),
          ),
        ],
      ),
    );
  }
}
