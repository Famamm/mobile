import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_event.dart';
import 'package:fleetops_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:fleetops_mobile/features/profile/presentation/pages/admin/admin_account_settings_page.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';

import '../../blocs/admin_profile_bloc.dart';
import '../../blocs/admin_profile_event.dart';
import '../../blocs/admin_profile_state.dart';
import '../../widgets/logout_confirmation_dialog.dart';
import '../app_infromation.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  static const String routeName = '/admin-profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminProfileBloc>()..add(const LoadAdminProfileEvent()),
      child: const _AdminProfileView(),
    );
  }
}

class _AdminProfileView extends StatelessWidget {
  const _AdminProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar(title: 'Profil Admin'),
      body: BlocBuilder<AdminProfileBloc, AdminProfileState>(
        builder: (context, state) {
          if (state is AdminProfileLoading || state is AdminProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is AdminProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 52,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.read<AdminProfileBloc>().add(
                        const LoadAdminProfileEvent(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = (state as AdminProfileLoaded).entity;

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
                          Icons.person_outline,
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
                          Icons.email_outlined,
                          color: AppColors.primary,
                        ),
                        title: const Text('Email'),
                        subtitle: Text(profile.email),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Akun
                const Text(
                  'Akun',
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
                      Icons.settings_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text('Pengaturan Akun'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AdminAccountSettingsPage(profile: profile),
                      ),
                    ),
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
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
