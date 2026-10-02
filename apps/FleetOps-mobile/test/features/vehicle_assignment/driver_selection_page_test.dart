import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_bloc.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_event.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_state.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/pages/driver_selection_page.dart';

import 'vehicle_assignment_test_helpers.dart';

void main() {
  // Payload mentah dengan variasi key nama & SIM yang dipakai backend.
  final rawDrivers = <Map<String, dynamic>>[
    {'id': 1, 'fullName': 'Budi Santoso', 'jenisLisensi': 'SIM A'},
    {'driverId': 2, 'namaDriver': 'Agus Hidayat', 'jenisLisensi': 'B2 Umum'},
    {
      'id': 3,
      'user': {'fullName': 'Dedi Ariyanto'},
      'licenseType': 'SIM C',
    },
    {'id': 4, 'profilePhoto': null},
  ];

  Future<VehicleAssignmentBloc> pumpPage(WidgetTester tester) async {
    final bloc = buildBloc(
      FakeVehicleAssignmentRepository(
        vehicles: [buildVehicle()],
        drivers: driversFromJson(rawDrivers),
      ),
    );
    addTearDown(bloc.close);

    // Halaman kendaraan memuat assignment dulu sebelum membuka halaman ini.
    bloc.add(LoadVehicleAssignmentEvent());
    await tester.pump();
    expect(bloc.state, isA<VehicleAssignmentLoaded>());

    await tester.pumpWidget(
      MaterialApp(
        home: DriverSelectionPage(vehicle: buildVehicle(), bloc: bloc),
      ),
    );
    await tester.pumpAndSettle();
    return bloc;
  }

  ElevatedButton confirmButton(WidgetTester tester) =>
      tester.widget(find.widgetWithText(ElevatedButton, 'Konfirmasi'));

  testWidgets(
    'menampilkan nama dari berbagai key API, inisial, dan label SIM tanpa '
    'duplikasi',
    (tester) async {
      setScreen(tester, const Size(1080, 2400));
      await pumpPage(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('PENGEMUDI TERSEDIA (4)'), findsOneWidget);

      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(find.text('Agus Hidayat'), findsOneWidget);
      expect(find.text('Dedi Ariyanto'), findsOneWidget);
      expect(find.text('Pengemudi DV-0004'), findsOneWidget);

      expect(find.text('BS'), findsOneWidget);
      expect(find.text('AH'), findsOneWidget);
      expect(find.text('DA'), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      expect(find.text('SIM A'), findsOneWidget);
      expect(find.text('SIM B2 Umum'), findsOneWidget);
      expect(find.text('SIM C'), findsOneWidget);
      expect(find.textContaining('SIM SIM'), findsNothing);
    },
  );

  testWidgets('memilih pengemudi tidak crash dan bisa dibatalkan', (
    tester,
  ) async {
    setScreen(tester, const Size(1080, 2400));
    await pumpPage(tester);
    expect(confirmButton(tester).onPressed, isNull);

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();

    // Sebelumnya: type '() => Driver' is not a subtype of type
    // '(() => DriverModel)?' of 'orElse'.
    expect(tester.takeException(), isNull);
    expect(find.text('Budi Santoso'), findsNWidgets(2));
    expect(confirmButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Budi Santoso').first);
    await tester.pumpAndSettle();
    expect(find.text('Belum dipilih'), findsOneWidget);
    expect(confirmButton(tester).onPressed, isNull);
  });

  testWidgets('pencarian dan filter SIM menyaring daftar', (tester) async {
    setScreen(tester, const Size(1080, 2400));
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), 'agus');
    await tester.pumpAndSettle();
    expect(find.text('PENGEMUDI TERSEDIA (1)'), findsOneWidget);
    expect(find.text('Agus Hidayat'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);

    await tester.enterText(find.byType(TextField), 'tidak ada');
    await tester.pumpAndSettle();
    expect(find.text('Pengemudi tidak ditemukan'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Filter SIM'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'SIM A'));
    await tester.pumpAndSettle();
    expect(find.text('PENGEMUDI TERSEDIA (1)'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Agus Hidayat'), findsNothing);
  });

  testWidgets('tetap rapi di layar 320dp dengan ukuran huruf 130%', (
    tester,
  ) async {
    setScreen(tester, const Size(320, 640), textScale: 1.3);
    await pumpPage(tester);

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
