import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../domain/entities/trip_history.dart';
import '../widgets/page_button.dart';
import '../blocs/trip_history_bloc.dart';
import '../blocs/trip_history_event.dart';
import '../blocs/trip_history_state.dart';
import '../widgets/cards/trip_history_card.dart';
import '../widgets/screens/trip_history_skeleton.dart';

class TabHistoryTrip extends StatefulWidget {
  const TabHistoryTrip({Key? key}) : super(key: key);

  @override
  State<TabHistoryTrip> createState() => _TabHistoryTripState();
}

class _TabHistoryTripState extends State<TabHistoryTrip> {
  static const int _pageSize = 5;
  int _currentPage = 0;
  Timer? _autoRefreshTimer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _setupAutoRefresh(List<TripHistory> trips) {
    if (trips.isEmpty) {
      _autoRefreshTimer?.cancel();
      _autoRefreshTimer = Timer.periodic(
        const Duration(seconds: 10),
        (_) => _loadHistory(),
      );
    } else {
      _autoRefreshTimer?.cancel();
    }
  }

  void _loadHistory() {
    final driverId = sl<TokenService>().getDriverId() ?? 0;
    context.read<TripHistoryBloc>().add(LoadTripHistory(driverId: driverId));
  }

  Future<void> _handleRefresh() async {
    setState(() => _currentPage = 0);
    _loadHistory();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat perjalanan Anda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SearchBarField(
                controller: _searchController,
                hintText: 'Cari lokasi atau tanggal (15-06-2026)...',
                onChanged: (v) => setState(() {
                  _searchQuery = v;
                  _currentPage = 0;
                }),
                onCleared: () => setState(() {
                  _searchQuery = '';
                  _currentPage = 0;
                }),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomRefreshIndicator(
            onRefresh: _handleRefresh,
            backgroundColor: AppColors.white,
            child: BlocListener<TripHistoryBloc, TripHistoryState>(
              listener: (context, state) {
                if (state is TripHistoryError) {
                  SnackBarUtil.showError(context, state.message);
                }
                if (state is TripHistoryLoaded) {
                  _setupAutoRefresh(state.trips);
                }
              },
              child: BlocBuilder<TripHistoryBloc, TripHistoryState>(
                builder: (context, state) {
                  if (state is TripHistoryLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: const TripHistorySkeleton(),
                    );
                  }

                  if (state is TripHistoryError) {
                    return _buildErrorState(context);
                  }

                  if (state is TripHistoryLoaded) {
                    final allTrips = state.trips;
                    if (allTrips.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    final trips = _filterTrips(allTrips);
                    if (trips.isEmpty) {
                      return _buildSearchEmptyState();
                    }
                    return _buildPaginatedList(trips);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TripHistory> _filterTrips(List<TripHistory> trips) {
    if (_searchQuery.isEmpty) return trips;
    final q = _searchQuery.toLowerCase();
    return trips.where((t) {
      final matchLokasi = t.startLocation.toLowerCase().contains(q) ||
          t.endLocation.toLowerCase().contains(q);
      final matchTanggal =
          '${t.date.day.toString().padLeft(2, '0')}-${t.date.month.toString().padLeft(2, '0')}-${t.date.year}'
              .contains(q);
      return matchLokasi || matchTanggal;
    }).toList();
  }

  Widget _buildSearchEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil untuk\n"$_searchQuery"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
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

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.route_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada riwayat perjalanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Riwayat perjalanan Anda akan muncul di sini setelah menyelesaikan trip.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    elevation: 0,
                  ),
                  onPressed: _handleRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                Gap(4.0),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    context.read<BottomNavCubit>().changeTab(1);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Mulai Perjalanan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginatedList(List<TripHistory> trips) {
    final totalPages = (trips.length / _pageSize).ceil();
    final safePage = _currentPage.clamp(0, totalPages - 1);
    final start = safePage * _pageSize;
    final end = (start + _pageSize).clamp(0, trips.length);
    final pageTrips = trips.sublist(start, end);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: pageTrips.length,
            itemBuilder: (context, index) => TripCard(trip: pageTrips[index]),
          ),
        ),
        _buildPaginationBar(totalPages, safePage, trips.length),
      ],
    );
  }

  Widget _buildPaginationBar(int totalPages, int currentPage, int totalItems) {
    final start = currentPage * _pageSize + 1;
    final end = ((currentPage + 1) * _pageSize).clamp(0, totalItems);

    // Generate page numbers with ellipsis
    List<dynamic> getVisiblePages() {
      const int maxVisible = 3; // Maksimal 5 halaman yang terlihat
      List<dynamic> pages = [];

      if (totalPages <= maxVisible) {
        // Jika total halaman sedikit, tampilkan semua
        for (int i = 0; i < totalPages; i++) {
          pages.add(i);
        }
      } else {
        // Selalu tampilkan halaman pertama
        pages.add(0);

        if (currentPage > 2) {
          pages.add('...');
        }

        // Tampilkan halaman sekitar current page
        int startPage = (currentPage - 1).clamp(1, totalPages - 2);
        int endPage = (currentPage + 1).clamp(1, totalPages - 2);

        for (int i = startPage; i <= endPage; i++) {
          if (i > 0 && i < totalPages - 1 && !pages.contains(i)) {
            pages.add(i);
          }
        }

        if (currentPage < totalPages - 3) {
          pages.add('...');
        }

        // Selalu tampilkan halaman terakhir
        if (totalPages - 1 > 0 && !pages.contains(totalPages - 1)) {
          pages.add(totalPages - 1);
        }
      }

      return pages;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$start–$end dari $totalItems trip',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              // Tombol Previous
              PageButton(
                icon: Icons.chevron_left_rounded,
                enabled: currentPage > 0,
                onTap: () => setState(() => _currentPage = currentPage - 1),
              ),
              const SizedBox(width: 4),

              // Page numbers dengan ellipsis
              ...getVisiblePages().map((page) {
                if (page == '...') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '...',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                final int pageNum = page as int;
                final bool isActive = pageNum == currentPage;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () => setState(() => _currentPage = pageNum),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color:
                            isActive ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: isActive
                            ? null
                            : Border.all(color: AppColors.grey300),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${pageNum + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(width: 4),
              // Tombol Next
              PageButton(
                icon: Icons.chevron_right_rounded,
                enabled: currentPage < totalPages - 1,
                onTap: () => setState(() => _currentPage = currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
