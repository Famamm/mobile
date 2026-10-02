import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Label rentang waktu untuk chart dashboard admin.
String adminRangeLabel(String range) {
  switch (range) {
    case 'month':
      return '1 Bulan';
    case 'year':
      return '1 Tahun';
    default:
      return '1 Minggu';
  }
}

/// Segmented control pemilih rentang waktu (1 Minggu / 1 Bulan / 1 Tahun).
class AdminRangeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const AdminRangeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _options = {
    'week': '1 Minggu',
    'month': '1 Bulan',
    'year': '1 Tahun',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _options.entries.map((entry) {
          final selected = entry.key == value;
          return GestureDetector(
            onTap: () => onChanged(entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Satu baris rincian (label kiri, nilai kanan).
class AdminChartDetailRow {
  final String label;
  final String value;

  const AdminChartDetailRow({required this.label, required this.value});
}

/// Blok rincian di bawah footer kartu chart.
class AdminChartDetail {
  final String title;
  final List<AdminChartDetailRow> rows;

  const AdminChartDetail({required this.title, required this.rows});
}

/// Kartu chart dashboard admin: judul + pemilih rentang, chart, footer total,
/// dan blok rincian opsional.
class AdminChartCard extends StatelessWidget {
  final String title;
  final String? range;
  final ValueChanged<String>? onRangeChanged;
  final Widget chart;
  final String footerLabel;
  final String footerValue;
  final AdminChartDetail? detail;

  const AdminChartCard({
    super.key,
    required this.title,
    required this.chart,
    required this.footerLabel,
    required this.footerValue,
    this.range,
    this.onRangeChanged,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final showSelector = range != null && onRangeChanged != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (showSelector)
                AdminRangeSelector(value: range!, onChanged: onRangeChanged!),
            ],
          ),
          const SizedBox(height: 20),
          chart,
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 12),
          Text(
            footerLabel,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            footerValue,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.grey200),
            const SizedBox(height: 12),
            Text(
              detail!.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            for (final row in detail!.rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      row.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      row.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Placeholder saat chart tidak memiliki data.
class AdminChartEmpty extends StatelessWidget {
  final String message;

  const AdminChartEmpty({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Nama bulan singkat berbahasa Indonesia.
const List<String> adminMonthShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Format label sumbu-X: "20 Sep" untuk harian, "Sep" untuk bulanan.
String adminAxisDateLabel(DateTime date, String range) {
  if (range == 'year') {
    return adminMonthShort[date.month - 1];
  }
  return '${date.day} ${adminMonthShort[date.month - 1]}';
}

/// Interval label sumbu-X agar tidak terlalu rapat.
double adminBottomInterval(int length) {
  if (length <= 8) return 1;
  return (length / 6).ceilToDouble();
}

/// Format angka rupiah dengan pemisah ribuan, contoh: "Rp 1.250.000".
String adminFormatCurrency(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'Rp $buffer';
}

/// Format ringkas untuk label sumbu-Y, contoh: "Rp1,5jt" / "Rp250rb" / "Rp0".
String adminCompactCurrency(num value) {
  if (value >= 1000000) {
    return 'Rp${(value / 1000000).toStringAsFixed(1).replaceAll('.', ',')}jt';
  }
  if (value >= 1000) {
    return 'Rp${(value / 1000).toStringAsFixed(0)}rb';
  }
  return 'Rp${value.toInt()}';
}
