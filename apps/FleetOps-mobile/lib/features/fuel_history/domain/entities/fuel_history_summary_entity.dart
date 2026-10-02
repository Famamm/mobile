class FuelHistorySummaryEntity {
  final double totalBiaya;
  final double rataRataKonsumsi;
  final double totalBiayaChangePercent;
  final bool isOptimalRange;

  const FuelHistorySummaryEntity({
    required this.totalBiaya,
    required this.rataRataKonsumsi,
    required this.totalBiayaChangePercent,
    required this.isOptimalRange,
  });
}
