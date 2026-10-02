String formatNotificationTime(String createdAt) {
  if (createdAt.isEmpty) return '';

  DateTime parsed;
  try {
    parsed = DateTime.parse(createdAt).toLocal();
  } catch (_) {
    return createdAt; // fallback kalau bukan format ISO
  }

  final now = DateTime.now();
  final diff = now.difference(parsed);

  // Kalau kurang dari 24 jam → tampilkan "x jam yang lalu" / "x menit yang lalu"
  if (diff.inHours < 24) {
    if (diff.inMinutes < 1) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit yang lalu';
    } else {
      return '${diff.inHours} jam yang lalu';
    }
  }

  // Kalau >= 24 jam → tampilkan tanggal
  const bulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  final day = parsed.day;
  final month = bulan[parsed.month - 1];
  final year = parsed.year;

  // Kalau tahun sama dengan sekarang → tanpa tahun
  if (parsed.year == now.year) {
    return '$day $month';
  }
  return '$day $month $year';
}