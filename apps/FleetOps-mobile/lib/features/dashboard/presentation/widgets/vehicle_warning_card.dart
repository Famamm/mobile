import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../../../profile/presentation/blocs/profile_event.dart';
import '../../../profile/presentation/blocs/profile_state.dart';
import '../../../profile/presentation/pages/driver/driver_profile_page.dart';

class VehicleWarningCard extends StatefulWidget {
  final String platNomor;

  const VehicleWarningCard({super.key, required this.platNomor});

  @override
  State<VehicleWarningCard> createState() => _VehicleWarningCardState();
}

class _VehicleWarningCardState extends State<VehicleWarningCard> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = sl<ProfileBloc>()..add(const LoadProfileEvent());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const LoadProfileEvent()),
          child: const DriverProfilePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          // Netral selama belum tahu pasti (loading/error) — jangan menuduh
          // admin belum menambahkan kendaraan tanpa konfirmasi kendaraanTersedia.
          final hasNoVehicle = profileState is ProfileLoaded &&
              profileState.entity.kendaraanTersedia.isEmpty;

          final title =
              hasNoVehicle ? 'Belum ada kendaraan' : 'Kendaraan belum dipilih';
          final subtitle = hasNoVehicle
              ? 'Admin organisasi belum menambahkan kendaraan. Hubungi admin organisasi untuk menambahkan kendaraan.'
              : 'Pilih kendaraan aktif di halaman Profil sebelum memulai perjalanan.';

          return _buildCard(context, title, subtitle, hasNoVehicle);
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle,
    bool hasNoVehicle,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFFB300),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF7A5200),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A5200),
                  ),
                ),
                if (!hasNoVehicle) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _goToProfile(context),
                    child: const Text(
                      'Pilih kendaraan di Profil →',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFB300),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
