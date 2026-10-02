import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  // ─────────────────────────────────────────────────────────
  // Konfigurasi — ubah sesuai kebutuhan
  // ─────────────────────────────────────────────────────────
  static const _appVersion = '3.0.3';
  static const _websiteUrl = 'https://app.fleetops.my.id';
  static const _email = 'fle3tops@gmail.com';
  static const _phone = '+62 813-8002-7869';
  static const _companyName = 'FleetOps';
  static const _companyAddress =
      'Jl. Raya ITS, Keputih, Kecamatan Sukolilo, Kota Surabaya, Jawa Timur 60111';
  static const _privacyUrl = 'https://privacy-policy-aw1v.vercel.app/';

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka $url')),
        );
      }
    }
  }

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: _email);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi email')),
        );
      }
    }
  }

  Future<void> _openPhone(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: _phone.replaceAll(' ', ''));
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
        );
      }
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'FleetOps',
      applicationVersion: _appVersion,
      applicationIcon: const Padding(
        padding: EdgeInsets.all(12),
        child: Image(
          image: AssetImage('assets/images/Logo FleetOps4.png'),
          width: 48,
          height: 48,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomSimpleAppBar(title: 'Informasi Aplikasi'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────── Logo & Nama Aplikasi ───────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Image.asset(
                      'assets/images/Logo FleetOps4.png',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FleetOps',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Versi $_appVersion',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─────────── Hubungi Kami ───────────
            _SectionTitle('Hubungi Kami'),
            const SizedBox(height: 8),
            _InfoCard(
              children: [
                _InfoTile(
                  icon: Icons.language,
                  label: 'Website',
                  value: _websiteUrl,
                  onTap: () => _openUrl(context, _websiteUrl),
                ),
                const _Divider(),
                _InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: _email,
                  onTap: () => _openEmail(context),
                ),
                const _Divider(),
                _InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Telepon',
                  value: _phone,
                  onTap: () => _openPhone(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─────────── Legal ───────────
            _SectionTitle('Legal'),
            const SizedBox(height: 8),
            _InfoCard(
              children: [
                _InfoTile(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Kebijakan Privasi',
                  onTap: () => _openUrl(context, _privacyUrl),
                ),
                const _Divider(),
                _InfoTile(
                  icon: Icons.article_outlined,
                  label: 'Lisensi Perangkat Lunak',
                  onTap: () => _showLicenses(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─────────── Perusahaan ───────────
            _SectionTitle('Tentang Perusahaan'),
            const SizedBox(height: 8),
            _InfoCard(
              children: [
                _InfoTile(
                  icon: Icons.business_outlined,
                  label: 'Nama Perusahaan',
                  value: _companyName,
                ),
                const _Divider(),
                _InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'Alamat',
                  value: _companyAddress,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ─────────── Footer ───────────
            Center(
              child: Column(
                children: [
                  Text(
                    '© ${DateTime.now().year} $_companyName',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Widget pendukung
// ═══════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        value!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey400,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 52),
      child: Divider(height: 1, color: AppColors.grey200),
    );
  }
}