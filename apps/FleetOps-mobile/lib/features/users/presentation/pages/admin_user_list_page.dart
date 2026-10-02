import 'package:fleetops_mobile/features/driver/presentation/pages/admin_detail_driver_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../../../driver/presentation/pages/admin_add_driver_page.dart';
import '../../../fleet_manager/presentation/pages/admin_add_fleet_manager_page.dart';
import '../../../fleet_manager/presentation/pages/admin_detail_fleet_manager_page.dart';
import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../navigation/presentation/blocs/bottom_nav_state.dart';
import '../../domain/entities/user.dart';
import '../blocs/user_list_bloc.dart';
import '../blocs/user_list_event.dart';
import '../blocs/user_list_state.dart';

class AdminUserListPage extends StatefulWidget {
  const AdminUserListPage({super.key});

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  late final UserListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<UserListBloc>()..add(LoadUsers());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listener: (context, navState) {
          if (navState is BottomNavChanged && navState.index == 2) {
            _bloc.add(LoadUsers());
          }
        },
        child: const _UserListView(),
      ),
    );
  }
}

class _UserListView extends StatefulWidget {
  const _UserListView();

  @override
  State<_UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<_UserListView> {
  String _selectedFilter = 'Semua';
  static const _filters = ['Semua', 'Pengemudi', 'Manajer Armada'];
  static const _pageSize = 5;

  UserRole? get _activeRole {
    switch (_selectedFilter) {
      case 'Pengemudi':
        return UserRole.driver;
      case 'Manajer Armada':
        return UserRole.fleetManager;
      default:
        return null;
    }
  }

  List<User> _filteredUsers(List<User> users) {
    final role = _activeRole;
    if (role == null) return users;
    return users.where((u) => u.role == role).toList();
  }

  /// Reset ke halaman 1 saat filter berubah
  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
    final bloc = context.read<UserListBloc>();
    if (bloc.state is UserListLoaded) {
      bloc.add(ChangePage(1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListLoading || state is UserListInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is UserListError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<UserListBloc>().add(LoadUsers()),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final loadedState = state as UserListLoaded;
          final users = loadedState.users;

          // ── Statistik ──
          final totalUsers = users.length;
          final totalActive = users.where((u) => u.isActive).length;
          final totalDrivers = users
              .where((u) => u.role == UserRole.driver)
              .length;
          final totalFleetManagers = users
              .where((u) => u.role == UserRole.fleetManager)
              .length;

          // ── Filter + Pagination ──
          final filtered = _filteredUsers(users);
          final totalPages = (filtered.length / _pageSize).ceil();
          final currentPage = loadedState.currentPage.clamp(
            1,
            totalPages == 0 ? 1 : totalPages,
          );
          final startIndex = (currentPage - 1) * _pageSize;
          final endIndex = (startIndex + _pageSize).clamp(0, filtered.length);
          final paginatedUsers = startIndex < filtered.length
              ? filtered.sublist(startIndex, endIndex)
              : <User>[];

          return CustomRefreshIndicator(
            onRefresh: () async {
              context.read<UserListBloc>().add(LoadUsers());
              await context.read<UserListBloc>().stream.firstWhere(
                (s) => s is! UserListLoading,
              );
            },
            child: CustomScrollView(
              slivers: [
                // ── Statistik ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Total Pengguna',
                                value: '$totalUsers',
                                unit: 'Pengguna',
                                icon: Icons.person_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Pengguna Aktif',
                                value: '$totalActive',
                                unit: 'Pengguna',
                                icon: Icons.person_add_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Total Pengemudi',
                                value: '$totalDrivers',
                                unit: 'Pengemudi',
                                icon: Icons.drive_eta_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Total FM',
                                value: '$totalFleetManagers',
                                unit: 'Fleet Manager',
                                icon: Icons.manage_accounts_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Judul ──
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      'Daftar Pengguna',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ── Filter Chips ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: FilterChips(
                      chipWidth: 140,
                      filters: _filters,
                      selectedFilter: _selectedFilter,
                      onSelected: _onFilterChanged,
                    ),
                  ),
                ),

                // ── List (per halaman) ──
                if (paginatedUsers.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'Tidak ada pengguna untuk filter ini',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final user = paginatedUsers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: _Avatar(user: user),
                            title: Text(
                              user.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(_subtitleFor(user)),
                            trailing: GestureDetector(
                              onTap: () => _onTapUser(context, user),
                              child: Text(
                                'Detail',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: paginatedUsers.length),
                  ),

                // ── Pagination Controls ──
                if (totalPages > 1)
                  SliverToBoxAdapter(
                    child: _PaginationControls(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      onPageChanged: (page) =>
                          context.read<UserListBloc>().add(ChangePage(page)),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton(
          heroTag: 'fab_user_list',
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final added = await _showAddUserSheet(ctx);
            if (added == true && ctx.mounted) {
              ctx.read<UserListBloc>().add(LoadUsers());
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  String _subtitleFor(User user) {
    if (user.isDriver && user.driverId != null) {
      return 'ID : DV${user.driverId.toString().padLeft(4, '0')}';
    }
    return 'ID : US${user.userId.toString().padLeft(4, '0')}';
  }

  void _onTapUser(BuildContext context, User user) async {
    if (user.isDriver && user.driverId != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDriverDetailPage(driverId: user.driverId!),
        ),
      );
    } else if (user.isFleetManager) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDetailFleetManagerPage(fleetId: user.userId),
        ),
      );
    }
    if (context.mounted) {
      context.read<UserListBloc>().add(LoadUsers());
    }
  }
}

// ── Avatar Widget ──
class _Avatar extends StatelessWidget {
  final User user;
  const _Avatar({required this.user});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = user.profilePhoto != null && user.profilePhoto!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        color: AppColors.primary.withOpacity(0.15),
        child: hasPhoto
            ? Image.network(
                user.profilePhoto!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(_roleIcon(), size: 20, color: AppColors.primary),
              )
            : Icon(_roleIcon(), size: 20, color: AppColors.primary),
      ),
    );
  }

  IconData _roleIcon() {
    switch (user.role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.fleetManager:
        return Icons.manage_accounts;
      case UserRole.driver:
        return Icons.drive_eta_rounded;
      case UserRole.unknown:
        return Icons.person;
    }
  }
}

// ── Stat Card ──
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              Icon(icon, size: 18, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: unit, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pagination Controls Widget ──
class _PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            'Halaman $currentPage dari $totalPages',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PageButton(
                icon: Icons.chevron_left,
                enabled: currentPage > 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 8),
              ..._buildPageNumbers(),
              const SizedBox(width: 8),
              _PageButton(
                icon: Icons.chevron_right,
                enabled: currentPage < totalPages,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    final pages = <Widget>[];
    const maxVisible = 5;

    int start = (currentPage - 2).clamp(1, totalPages);
    int end = (start + maxVisible - 1).clamp(1, totalPages);

    if (end == totalPages) {
      start = (end - maxVisible + 1).clamp(1, totalPages);
    }

    for (int i = start; i <= end; i++) {
      pages.add(
        _PageNumberButton(
          page: i,
          isActive: i == currentPage,
          onTap: () => onPageChanged(i),
        ),
      );
      if (i < end) pages.add(const SizedBox(width: 4));
    }

    return pages;
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? AppColors.white : AppColors.grey300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── FAB Bottom Sheet ──
Future<bool?> _showAddUserSheet(BuildContext context) async {
  final choice = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tambah Pengguna Baru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.bgprimary,
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              title: const Text('Driver'),
              subtitle: const Text('Tambahkan pengemudi baru'),
              onTap: () => Navigator.pop(sheetCtx, 'driver'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.bgprimary,
                child: const Icon(
                  Icons.manage_accounts,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('Fleet Manager'),
              subtitle: const Text('Tambahkan fleet manager baru'),
              onTap: ()  => Navigator.pop(sheetCtx, 'fleet_manager'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );

  if (choice == null || !context.mounted) return null;

  final bool? added;
  if (choice == 'driver') {
    added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AdminAddDriverPage()),
    );
  } else {
    added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AdminAddFleetManagerPage()),
    );
  }

  return added;
}
