import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../domain/entities/admin_dashboard_entity.dart';
import 'admin_chart_card.dart';

/// Chart garis total biaya BBM per hari/bulan.
class AdminBbmCostChart extends StatelessWidget {
  final List<AdminBbmActivityDay> data;
  final double totalLiter;
  final int totalHarga;
  final int jenisCount;
  final String range;
  final ValueChanged<String>? onRangeChanged;

  const AdminBbmCostChart({
    super.key,
    required this.data,
    required this.totalLiter,
    required this.totalHarga,
    required this.jenisCount,
    required this.range,
    this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hargaPerLiter = totalLiter > 0
        ? (totalHarga / totalLiter).round()
        : 0;

    return AdminChartCard(
      title: 'Biaya Bahan Bakar',
      range: range,
      onRangeChanged: onRangeChanged,
      footerLabel: 'Total Biaya BBM - ${adminRangeLabel(range)}',
      footerValue: adminFormatCurrency(totalHarga),
      detail: AdminChartDetail(
        title: 'Rincian Biaya BBM',
        rows: [
          AdminChartDetailRow(
            label: 'Total Konsumsi',
            value: '${totalLiter.toStringAsFixed(0)} L',
          ),
          AdminChartDetailRow(label: 'Jenis BBM', value: '$jenisCount jenis'),
          AdminChartDetailRow(
            label: 'Harga per Liter',
            value: adminFormatCurrency(hargaPerLiter),
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
                  message: 'Belum ada data biaya BBM',
                )
              : KeyedSubtree(
                  key: const ValueKey('bbm-chart'),
                  child: _buildChart(),
                ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    final maxValue = data
        .map((e) => e.totalHarga)
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
              reservedSize: 48,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                if (value == meta.max) return const SizedBox.shrink();
                return Text(
                  adminCompactCurrency(value),
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
                    adminFormatCurrency(spot.y),
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
                FlSpot(i.toDouble(), data[i].totalHarga.toDouble()),
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
