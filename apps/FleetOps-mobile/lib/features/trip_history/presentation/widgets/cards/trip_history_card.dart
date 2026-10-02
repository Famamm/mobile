import 'package:fleetops_mobile/features/trip_history/domain/entities/trip_history.dart';
import 'package:fleetops_mobile/features/trip/presentation/pages/trip_detail_page.dart';
import 'package:fleetops_mobile/features/trip/presentation/widgets/components/info_item.dart';
import 'package:fleetops_mobile/features/trip/presentation/widgets/components/trip_status.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:gap/gap.dart';

class TripCard extends StatelessWidget {
  final TripHistory trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail perjalanan
        Navigator.pushNamed(context, TripDetailPage.routeName, arguments: trip);
      },
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: AppColors.grey200, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tampilkan tanggal dan status di bar atas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppColors.grey300, width: 1.0),
                    ),
                    child: Text(
                      trip.date.toString().substring(0, 10),
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TripStatus(status: trip.status),
                ],
              ),
              Gap(16.0),
              // Tampilkan rute perjalanan di bawahnya
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titik Awal',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                      Text(
                        "${trip.startLocation}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titik akhir',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                      Text(
                        "${trip.endLocation}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(color: AppColors.grey300, thickness: 1.0),
              SizedBox(height: 8.0),
              // KETERANGAN DURASI DAN JARAK
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InfoItem(
                        icon: Icons.access_time,
                        label: 'Durasi',
                        value: trip.durasi,
                      ),
                    ),
                    const Gap(12.0),
                    Expanded(
                      child: InfoItem(
                        icon: Icons.map_outlined,
                        label: 'Jarak',
                        value: trip.jarak,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
