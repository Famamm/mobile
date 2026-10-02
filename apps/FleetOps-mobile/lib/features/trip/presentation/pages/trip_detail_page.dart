import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../../../trip_history/domain/entities/trip_history.dart';
import '../../data/models/get_detail_trip_dto.dart';
import '../../domain/repositories/trip_repository.dart';
import '../widgets/cards/trip_detail_card.dart';
import '../widgets/components/trip_timeline.dart';

class TripDetailPage extends StatefulWidget {
  const TripDetailPage({super.key});

  static const String routeName = '/trip-detail';

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late TripHistory trip;
  List<String> _photos = [];
  String? _catatan;
  double? _avgSpeed;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    trip = ModalRoute.of(context)!.settings.arguments as TripHistory;
    if (trip.tripId > 0) _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final GetDetailTripDTO detail = await sl<TripRepository>().getTripDetail(
        trip.tripId,
      );
      if (!mounted) return;
      final photos = detail.details
          .where((d) => d.imageUrl != null && d.imageUrl!.isNotEmpty)
          .map((d) => d.imageUrl!)
          .toList();
      // Hitung kecepatan rata-rata dengan presisi tinggi: total jarak / total waktu (jam)
      double? avgSpeed;
      if (detail.details.isNotEmpty) {
        final totalJarak = detail.details.fold<double>(
          0,
          (s, d) => s + d.jarak,
        );
        final totalWaktu = detail.details.fold<int>(0, (s, d) => s + d.waktu);
        if (totalWaktu > 0 && totalJarak > 0) {
          avgSpeed = totalJarak / (totalWaktu / 3600);
        }
      }
      setState(() {
        _photos = photos;
        _catatan = detail.catatan;
        _avgSpeed = avgSpeed;
      });
    } catch (_) {
      // Detail tidak tersedia — tampilkan placeholder
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar(
        title: 'Detail Perjalanan',
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail riwayat perjalanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TripDetailCard(
                  label: 'Total Jarak',
                  value: trip.jarak,
                  icon: Icons.location_on_sharp,
                ),
                TripDetailCard(
                  label: 'Total Waktu',
                  value: trip.durasi,
                  icon: Icons.access_time_filled,
                ),
              ],
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TripDetailCard(
                  label: 'Kecepatan Rata-rata',
                  value: _avgSpeed != null
                      ? '${_avgSpeed!.toStringAsFixed(1)} km/jam'
                      : trip.kecepatanRataRata,
                  icon: Icons.speed_sharp,
                ),
                TripDetailCard(
                  label: 'Konsumsi BBM',
                  value: trip.konsumsiBBM,
                  icon: Icons.local_gas_station_sharp,
                ),
              ],
            ),
            const Gap(16),
            CustomCard(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.folder_copy_outlined,
                        color: AppColors.primary,
                      ),
                      Gap(8),
                      Text('Dokumentasi Perjalanan'),
                    ],
                  ),
                  const Gap(8),
                  const Text(
                    'Foto Dokumentasi Perjalanan',
                    style: TextStyle(fontSize: 14, color: AppColors.grey500),
                  ),
                  const Gap(8),
                  SizedBox(
                    height: 100,
                    child: _photos.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Foto tidak tersedia',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _photos.length,
                            separatorBuilder: (_, i) => const Gap(8),
                            itemBuilder: (context, index) {
                              final url = _photos[index];
                              final fullUrl = url.startsWith('http')
                                  ? url
                                  : '${ApiConfig.baseUrl}$url';
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  fullUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (ctx, child, progress) =>
                                      progress == null
                                          ? child
                                          : Container(
                                              width: 100,
                                              color: AppColors.grey100,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                  errorBuilder: (ctx, err, trace) => Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const Gap(8),
                  const Text(
                    'Catatan Perjalanan',
                    style: TextStyle(fontSize: 14, color: AppColors.grey500),
                  ),
                  const Gap(8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (_catatan != null && _catatan!.isNotEmpty)
                          ? _catatan!
                          : (trip.note.isEmpty ? '-' : trip.note),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            CustomCard(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.route_outlined, color: AppColors.primary),
                      Gap(8),
                      Text('Timeline Perjalanan'),
                    ],
                  ),
                  const Gap(16),
                  TripTimeline(
                    stops: [
                      TripStop(
                        location: trip.startLocation,
                        time: 'MULAI • ${_formatTime(trip.date)}',
                        description: 'Berangkat dari titik awal',
                        type: TripStopType.start,
                      ),
                      TripStop(
                        location: trip.endLocation,
                        time: trip.waktuSelesai != null
                            ? 'SELESAI • ${_formatTime(trip.waktuSelesai!)}'
                            : 'SELESAI',
                        description: 'Tiba di lokasi tujuan',
                        type: TripStopType.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}
