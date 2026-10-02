import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:shared/shared.dart';

import '../../data/data_sources/fuel_history_remote_data_source.dart';
import '../../data/models/fuel_history_model.dart';
import '../../domain/entities/fuel_history_entity.dart';

class FuelHistoryDetailPage extends StatefulWidget {
  final String fuelId;

  const FuelHistoryDetailPage({super.key, required this.fuelId});

  @override
  State<FuelHistoryDetailPage> createState() => _FuelHistoryDetailPageState();
}

class _FuelHistoryDetailPageState extends State<FuelHistoryDetailPage> {
  late Future<FuelHistoryModel> _future;
  late final FuelHistoryRemoteDataSourceImpl _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource =
        FuelHistoryRemoteDataSourceImpl(httpService: sl<HttpService>());
    _future = _dataSource.getFuelDetail(widget.fuelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: CustomSimpleAppBar(title: 'Detail Bensin'),
      body: FutureBuilder<FuelHistoryModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail bensin.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => setState(() {
                        _future = _dataSource.getFuelDetail(widget.fuelId);
                      }),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                    ),
                  ],
                ),
              ),
            );
          }

          final item = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _VehicleHeaderCard(item: item),
                const SizedBox(height: 16),
                _SectionLabel(label: 'DETAIL PENGISIAN BBM'),
                const SizedBox(height: 8),
                _DetailCard(item: item),
                if (item.hasReceipt && item.receiptImageUrl != null) ...[
                  const SizedBox(height: 16),
                  _SectionLabel(label: 'FOTO STRUK BBM'),
                  const SizedBox(height: 8),
                  _ReceiptCard(imageUrl: item.receiptImageUrl!),
                ],
                if (item.note != null && item.note!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionLabel(label: 'CATATAN'),
                  const SizedBox(height: 8),
                  _NoteCard(note: item.note!),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _VehicleHeaderCard extends StatelessWidget {
  final FuelHistoryEntity item;
  const _VehicleHeaderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_gas_station_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.vehicleName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.plateNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(item.date)} • ${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')} WIB',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.grey400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }
}

class _DetailCard extends StatelessWidget {
  final FuelHistoryEntity item;
  const _DetailCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Jenis BBM',
            value: item.fuelType,
            valueStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            isFirst: true,
          ),
          const _Divider(),
          _DetailRow(
            label: 'Jumlah (Liter)',
            value: '${item.liters.toStringAsFixed(1)} Liter',
            valueStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const _Divider(),
          _DetailRow(
            label: 'Total Biaya',
            value: 'Rp ${_formatCurrency(item.totalCost)}',
            valueStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          if (item.odometer != null) ...[
            const _Divider(),
            _DetailRow(
              label: 'Odometer',
              value: '${_formatOdometer(item.odometer!)} KM',
              valueStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  String _formatCurrency(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _formatOdometer(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;
  final bool isFirst;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.valueStyle,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 16 : 14, 16, isLast ? 16 : 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: AppColors.borderLight);
}

class _ReceiptCard extends StatelessWidget {
  final String imageUrl;
  const _ReceiptCard({required this.imageUrl});

  void _viewFullImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _FullImagePage(imageUrl: imageUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.grey200,
                child: const Center(
                  child: Icon(Icons.broken_image_outlined,
                      color: AppColors.grey400, size: 40),
                ),
              ),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: AppColors.grey100,
                  child: const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => _viewFullImage(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.zoom_in_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Lihat Full',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullImagePage extends StatelessWidget {
  final String imageUrl;
  const _FullImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white,
                size: 60),
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        '"$note"',
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}
