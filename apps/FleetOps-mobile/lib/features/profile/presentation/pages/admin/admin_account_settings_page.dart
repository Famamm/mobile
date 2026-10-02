import 'package:fleetops_mobile/features/profile/domain/entities/admin_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

class AdminAccountSettingsPage extends StatefulWidget {
  final AdminProfileEntity profile;

  const AdminAccountSettingsPage({super.key, required this.profile});

  @override
  State<AdminAccountSettingsPage> createState() =>
      _AdminAccountSettingsPageState();
}

class _AdminAccountSettingsPageState extends State<AdminAccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomSimpleAppBar(title: 'Pengaturan Akun'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCardForm(
                    title: 'Informasi Akun',
                    formFields: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Foto profil
                          const Text(
                            'Foto Profil',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.grey50,
                            backgroundImage:
                                widget.profile.photoUrl != null &&
                                    widget.profile.photoUrl!.isNotEmpty
                                ? NetworkImage(widget.profile.photoUrl!)
                                : null,
                            child:
                                widget.profile.photoUrl == null ||
                                    widget.profile.photoUrl!.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 36,
                                    color: AppColors.grey400,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Nama
                          ReadOnlyField(
                            hintText: 'Nama Lengkap',
                            value: widget.profile.nama,
                            titleValue: 'Nama Lengkap',
                          ),
                          const SizedBox(height: 16),

                          // Username
                          ReadOnlyField(
                            hintText: 'Nama Pengguna',
                            value: widget.profile.username,
                            titleValue: 'Nama Pengguna',
                            showCopyButton: true,
                            onCopyPressed: () {
                              // Copy email to clipboard
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email berhasil disalin'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email
                          ReadOnlyField(
                            hintText: 'Email',
                            titleValue: 'Email',
                            value: widget.profile.email,
                          ),
                          const SizedBox(height: 16),

                          // Role
                          ReadOnlyField(
                            hintText: 'Role',
                            titleValue: 'Role',
                            value: widget.profile.role,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Edit Profil',
              onPressed: () {
                _showComingSoonDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.construction,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Fitur Sedang Dalam Pengembangan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                const Text(
                  'Maaf, fitur edit profil sedang dalam pengembangan. '
                  'Kami akan segera hadirkan fitur ini untuk Anda.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Button
                CustomButton(
                  text: 'Mengerti',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
