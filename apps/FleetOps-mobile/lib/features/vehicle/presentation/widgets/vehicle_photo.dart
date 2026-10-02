import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';

class VehiclePhoto extends StatelessWidget {
  final Vehicle vehicle;

  const VehiclePhoto({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        vehicle.imageUrl != null && vehicle.imageUrl!.isNotEmpty
            ? Image.network(
                vehicle.imageUrl!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: vehicle.status == 'Active' ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              vehicle.status == 'Active' ? 'AKTIF' : 'NONAKTIF',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 220,
      color: Colors.grey[200],
      child: const Icon(
        Icons.local_shipping_outlined,
        size: 64,
        color: Colors.grey,
      ),
    );
  }
}
