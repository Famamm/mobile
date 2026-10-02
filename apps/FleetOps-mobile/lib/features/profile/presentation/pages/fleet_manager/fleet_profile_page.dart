import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_event.dart';
import 'package:fleetops_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';

import '../../blocs/fleet_profile_bloc.dart';
import '../../blocs/fleet_profile_event.dart';
import '../../blocs/fleet_profile_state.dart';
import '../../widgets/logout_confirmation_dialog.dart';
import '../app_infromation.dart';

class FleetProfilePage extends StatelessWidget {
  const FleetProfilePage({super.key});

  static const String routeName = '/fleet-profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FleetProfileBloc>()..add(const LoadFleetProfileEvent()),
      child: const _FleetProvileView(),
    );
  }
}

class _FleetProvileView extends StatelessWidget {
  const _FleetProvileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar(title: 'Profil Fleet Manager'),
      body: BlocBuilder<FleetProfileBloc, FleetProfileState>(
        builder: (context, state) {
          if (state is FleetProfileLoading || state is FleetProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FleetProfileError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<FleetProfileBloc>().add(
                      const LoadFleetProfileEvent(),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final profile = (state as FleetProfileLoaded).entity;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child:
                            profile.photoUrl != null &&
                                profile.photoUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  profile.photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    size: 56,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 56,
                                color: AppColors.primary,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Informasi Akun',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                        ),
                        title: const Text('Nama'),
                        subtitle: Text(profile.nama),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: AppColors.grey200,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                        ),
                        title: const Text('Username'),
                        subtitle: Text(profile.username),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aplikasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text('Informasi Aplikasi'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AppInfoPage()),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Logout Button
                CustomButton(
                  text: 'Keluar',
                  color: AppColors.error,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => LogoutConfirmationDialog(
                        onConfirm: () {
                          Navigator.pop(context);
                          final refreshToken =
                              sl<TokenService>().getRefreshToken() ?? '';
                          context.read<AuthBloc>().add(
                            LogoutEvent(refreshToken: refreshToken),
                          );

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            WelcomePage.routeName,
                            (route) => false,
                          );
                        },
                      ),
                    );
                  },
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 24),
                  child: Text(
                    'Versi Aplikasi: V3.0.0',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
