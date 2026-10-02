class CreateDriverDTO {
  final String fullName;
  final String address;
  final String jenisLisensi;
  final String tanggalBerlaku;
  final String status;

  CreateDriverDTO({
    required this.fullName,
    required this.address,
    required this.jenisLisensi,
    required this.tanggalBerlaku,
    this.status = 'Active',
  });

  static String _formatDateForBackend(String value) {
    if (value.isEmpty) return value;
    try {
      final bulan = {
        'Januari': '01',
        'Februari': '02',
        'Maret': '03',
        'April': '04',
        'Mei': '05',
        'Juni': '06',
        'Juli': '07',
        'Agustus': '08',
        'September': '09',
        'Oktober': '10',
        'November': '11',
        'Desember': '12'
      };

      DateTime date;

      // Format: "12 Juni 2030"
      if (RegExp(r'^\d{1,2}\s+\w+\s+\d{4}$').hasMatch(value)) {
        final parts = value.split(' ');
        final hariStr = parts[0].padLeft(2, '0');
        final bulanNum = bulan[parts[1]] ?? '01';
        final tahun = parts[2];
        date = DateTime.parse('$tahun-$bulanNum-$hariStr');
      }
      // Format: "26/06/2030"
      else if (value.contains('/')) {
        final parts = value.split('/');
        date = DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
      // Format: ISO
      else {
        date = DateTime.parse(value);
      }

      return date.toIso8601String();
    } catch (e) {
      return value;
    }
  }

  Map<String, String> toFormFields() => {
        'FullName': fullName,
        'Address': address,
        'JenisLisensi': jenisLisensi,
        'TanggalBerlaku': _formatDateForBackend(tanggalBerlaku),
        'Status': status,
      };
}
