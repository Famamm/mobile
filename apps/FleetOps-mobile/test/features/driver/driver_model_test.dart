import 'package:flutter_test/flutter_test.dart';

import 'package:fleetops_mobile/features/driver/data/models/driver_model.dart';

void main() {
  group('DriverModel.fromJson nama pengemudi', () {
    final cases = <String, Map<String, dynamic>>{
      'fullName (endpoint admin)': {'fullName': 'Budi Santoso'},
      'name': {'name': 'Budi Santoso'},
      'namaDriver (seperti profil driver)': {'namaDriver': 'Budi Santoso'},
      'driverName (seperti dashboard driver)': {'driverName': 'Budi Santoso'},
      'user.fullName bersarang': {
        'user': {'fullName': 'Budi Santoso'},
      },
      'username sebagai cadangan terakhir': {'username': 'Budi Santoso'},
    };

    cases.forEach((description, json) {
      test('membaca $description', () {
        expect(DriverModel.fromJson({'id': 1, ...json}).name, 'Budi Santoso');
      });
    });

    test('fullName diutamakan dan nilai kosong dilewati', () {
      final driver = DriverModel.fromJson({
        'fullName': '  ',
        'namaDriver': 'Agus Hidayat',
        'username': 'agus',
      });
      expect(driver.name, 'Agus Hidayat');
    });

    test('tanpa key nama menghasilkan string kosong', () {
      expect(DriverModel.fromJson({'id': 1, 'fullName': null}).name, '');
    });
  });
}
