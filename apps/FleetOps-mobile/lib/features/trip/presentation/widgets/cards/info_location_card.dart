import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../components/info_item.dart';

class InfoLocationCard extends StatelessWidget {
  final String startLocation;
  const InfoLocationCard({
    super.key,
    required this.startLocation,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoItem(
            icon: Icons.location_on_rounded,
            label: 'Titik Awal',
            value: startLocation,
          ),
        ],
      ),
    );
  }
}
