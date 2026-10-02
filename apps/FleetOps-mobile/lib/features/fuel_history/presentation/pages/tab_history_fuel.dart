import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:shared/shared.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/data_sources/fuel_history_remote_data_source.dart';
import '../../domain/entities/fuel_history_entity.dart';
import '../widgets/fuel_history_card.dart';
import '../widgets/fuel_history_skeleton.dart';
import 'fuel_history_detail_page.dart';

class TabHistoryFuel extends StatefulWidget {
  const TabHistoryFuel({super.key});

  @override
  State<TabHistoryFuel> createState() => _TabHistoryFuelState();
}

class _TabHistoryFuelState extends State<TabHistoryFuel> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;
  List<FuelHistoryEntity> _items = [];

  late final FuelHistoryRemoteDataSourceImpl _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource =
        FuelHistoryRemoteDataSourceImpl(httpService: sl<HttpService>());
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final items = await _dataSource.getFuelHistories();
      if (mounted) setState(() => _items = items);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<FuelHistoryEntity> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items.where((item) {
      final tanggal =
          '${item.date.day.toString().padLeft(2, '0')}-${item.date.month.toString().padLeft(2, '0')}-${item.date.year}';
      return item.vehicleName.toLowerCase().contains(q) ||
          item.plateNumber.toLowerCase().contains(q) ||
          item.fuelType.toLowerCase().contains(q) ||
          tanggal.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Skeletonizer(
        enabled: true,
        effect: const ShimmerEffect(
          baseColor: AppColors.grey200,
          highlightColor: AppColors.grey100,
        ),
        child: const FuelHistorySkeleton(),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Bensin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            SearchBarField(
              controller: _searchController,
              hintText: 'Cari kendaraan, BBM, atau tanggal (15-06-2026)...',
              onChanged: (v) => setState(() => _searchQuery = v),
              onCleared: () => setState(() => _searchQuery = ''),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              _buildErrorState()
            else if (_items.isEmpty)
              _buildEmptyState()
            else if (_filteredItems.isEmpty)
              _buildSearchEmptyState()
            else
              ...(_filteredItems.map(
                (item) => FuelHistoryCard(
                  key: ValueKey(item.id),
                  item: item,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FuelHistoryDetailPage(fuelId: item.id),
                    ),
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat riwayat bensin.',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 48),
        child: Column(
          children: [
            Icon(Icons.local_gas_station_outlined,
                size: 48, color: AppColors.textSecondary),
            SizedBox(height: 12),
            Text(
              'Belum ada riwayat bensin.',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            SizedBox(height: 4),
            Text(
              'Riwayat pengisian BBM akan muncul di sini.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Tidak ada hasil untuk\n"$_searchQuery"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Coba kata kunci lain atau cek penulisan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
