import 'package:flutter/material.dart';
import 'package:core/core.dart';

class DocumentCard extends StatelessWidget {
  final String label;
  final String expiry;
  final String? fotoUrl;
  final VoidCallback? onLihat;

  const DocumentCard({
    super.key,
    required this.label,
    required this.expiry,
    this.fotoUrl,
    this.onLihat,
  });

  void _showFotoPreview(BuildContext context) {
    if (fotoUrl == null || fotoUrl!.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                child: Image.network(
                  fotoUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 240,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ],
        ),
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  'berlaku hingga $expiry',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(14)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _FotoLisensi(fotoUrl: fotoUrl),
                _LihatDokumenButton(
                  onTap: onLihat ?? () => _showFotoPreview(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FotoLisensi extends StatelessWidget {
  final String? fotoUrl;

  const _FotoLisensi({this.fotoUrl});

  @override
  Widget build(BuildContext context) {
    if (fotoUrl != null && fotoUrl!.isNotEmpty) {
      return Image.network(
        fotoUrl!,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 180,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported_outlined,
          size: 40, color: Colors.grey),
    );
  }
}

class _LihatDokumenButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _LihatDokumenButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.remove_red_eye_outlined,
                color: AppColors.primary, size: 18),
            SizedBox(width: 8),
            Text(
              'Lihat Dokumen',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
