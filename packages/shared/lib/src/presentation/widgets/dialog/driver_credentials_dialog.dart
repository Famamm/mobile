import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';

class DriverCredentialsDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? username;
  final String? password;
  final String buttonText;
  final VoidCallback onOk;

  const DriverCredentialsDialog({
    super.key,
    this.title = 'Pengguna Ditambahkan!',
    this.subtitle = 'Simpan kredensial berikut untuk login pengguna',
    this.username,
    this.password,
    this.buttonText = 'Oke',
    required this.onOk,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label disalin'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.bgprimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (username != null && username!.isNotEmpty) ...[
              _CredentialItem(
                label: 'Username',
                value: username!,
                onCopy: () => _copyToClipboard(context, username!, 'Username'),
              ),
              const SizedBox(height: 10),
            ],
            if (password != null && password!.isNotEmpty) ...[
              _CredentialItem(
                label: 'Password',
                value: password!,
                onCopy: () => _copyToClipboard(context, password!, 'Password'),
              ),
              const SizedBox(height: 4),
            ],
            if ((username == null || username!.isEmpty) &&
                (password == null || password!.isEmpty))
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Kredensial akan dikirimkan ke pengemudi.',
                  style:
                      TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onOk();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CredentialItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CredentialItem({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onCopy,
                child: const Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
