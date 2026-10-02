import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../domain/entities/admin_dashboard_entity.dart';
import 'admin_chart_card.dart';

/// Chart garis jumlah perjalanan armada per hari/bulan.
class AdminFleetActivityChart extends StatelessWidget {
  final List<AdminFleetActivityDay> data;
  final AdminRincianAktivitasArmada rincian;
  final String range;
  final ValueChanged<String>? onRangeChanged;

  const AdminFleetActivityChart({
    super.key,
    required this.data,
    required this.rincian,
    required this.range,
    this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<int>(0, (prev, e) => prev + e.jumlahPerjalanan);

    return AdminChartCard(
      title: 'Aktivitas Armada',
      range: range,
      onRangeChanged: onRangeChanged,
      footerLabel: 'Total Perjalanan - ${adminRangeLabel(range)}',
      footerValue: '$total perjalanan',
      detail: AdminChartDetail(
        title: 'Rincian Aktivitas Armada',
        rows: [
          AdminChartDetailRow(
            label: 'Total Jarak',
            value: '${rincian.totalJarak} km',
          ),
          AdminChartDetailRow(
            label: 'Total Durasi',
            value: '${rincian.totalDurasi} menit',
          ),
          AdminChartDetailRow(
            label: 'Rata-rata Kecepatan',
            value: '${rincian.rataRataKecepatan.toStringAsFixed(2)} km/jam',
          ),
        ],
      ),
      chart: SizedBox(
        height: 200,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: data.isEmpty
              ? const AdminChartEmpty(
                  key: ValueKey('empty'),
                  message: 'Belum ada data aktivitas armada',
                )
              : KeyedSubtree(
                  key: const ValueKey('armada-chart'),
                  child: _buildChart(),
                ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    final maxValue = data
        .map((e) => e.jumlahPerjalanan)
        .fold<int>(0, (prev, e) => e > prev ? e : prev);
    final maxY = (maxValue == 0 ? 4 : maxValue).toDouble() * 1.25;

    return LineChart(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: AppColors.grey200, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                if (value == meta.max) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: adminBottomInterval(data.length),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    adminAxisDateLabel(data[index].tanggal, range),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    '${spot.y.toInt()} perjalanan',
                    const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < data.length; i++)
                FlSpot(i.toDouble(), data[i].jumlahPerjalanan.toDouble()),
            ],
            isCurved: true,
            curveSmoothness: 0.25,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 3.5,
                color: AppColors.primary,
                strokeWidth: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
