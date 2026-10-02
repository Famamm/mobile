class DamageReportMapping {
  // ── Severity ──
  static const Map<String, int> severity = {
    'Ringan': 0,
    'Sedang': 1,
    'Berat': 2,
  };

  // ── OperationalStatus ──
  static const Map<String, int> operationalStatus = {
    'Beroperasi': 0,
    'Berhenti Aman': 1,
    'Tidak Dapat Beroperasi': 2,
  };

  static int getSeverity(String label) {
    final value = severity[label];
    if (value == null) {
      throw Exception('Severity "$label" tidak dikenal');
    }
    return value;
  }

  static int getOperationalStatus(String label) {
    final value = operationalStatus[label];
    if (value == null) {
      throw Exception('OperationalStatus "$label" tidak dikenal');
    }
    return value;
  }
}