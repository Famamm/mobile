import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fleetops_mobile/features/driver/data/models/driver_model.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_bloc.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_event.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/pages/vehicle_detail_page.dart';

import 'vehicle_assignment_test_helpers.dart';

void main() {
  final bambang = DriverModel.fromJson({
    'driverId': 81,
    'namaDriver': 'Bambang Susanto',
    'jenisLisensi': 'SIM B2 Umum',
  });
  final agus = DriverModel.fromJson({
    'driverId': 82,
    'namaDriver': 'Agus Hidayat',
    'jenisLisensi': 'SIM B1 Umum',
  });

  /// Mengikuti alur halaman daftar: muat assignment, lalu pengemudi saat ini.
  Future<VehicleAssignmentBloc> pumpDetail(
    WidgetTester tester,
    FakeVehicleAssignmentRepository repository, {
    Vehicle? vehicle,
  }) async {
    final target = vehicle ?? buildVehicle();
    final bloc = buildBloc(repository);
    addTearDown(bloc.close);
    bloc.add(LoadVehicleAssignmentEvent());
    await tester.pump();
    bloc.add(LoadCurrentDriverEvent(vehicleId: target.vehicleId));

    await tester.pumpWidget(
      MaterialApp(
        home: VehicleDetailPage(vehicle: target, bloc: bloc),
      ),
    );
    await tester.pump();
    return bloc;
  }

  const statusLabels = {
    'Active': 'Aktif',
    'Maintenance': 'Dalam Perawatan',
    'Inactive': 'Tidak Aktif',
  };

  for (final entry in statusLabels.entries) {
    testWidgets(
      'status ${entry.key} tampil sebagai "${entry.value}" tanpa overflow di '
      'layar 320dp',
      (tester) async {
        setScreen(tester, const Size(320, 640), textScale: 1.3);
        await pumpDetail(
          tester,
          FakeVehicleAssignmentRepository(currentDriver: bambang),
          vehicle: buildVehicle(status: entry.key),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('AB 1234 CDE · ${entry.value}'), findsOneWidget);
        expect(find.text('Pengemudi Saat Ini'), findsOneWidget);
      },
    );
  }

  testWidgets('kartu Total Jarak dan Jadwal Rutin sama tinggi', (tester) async {
    setScreen(tester, const Size(320, 640), textScale: 1.3);
    await pumpDetail(tester, FakeVehicleAssignmentRepository());
    await tester.pumpAndSettle();

    Size cardOf(String label) => tester.getSize(
      find
          .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
          .first,
    );

    expect(find.text('48.250'), findsOneWidget);
    expect(cardOf('ODOMETER').height, cardOf('SERVIS BERIKUTNYA').height);
  });

  testWidgets(
    'menampilkan status memuat, bukan "Belum ada pengemudi", sebelum data '
    'pengemudi tiba',
    (tester) async {
      setScreen(tester, const Size(390, 844));
      final repository = FakeVehicleAssignmentRepository(currentDriver: bambang)
        ..currentDriverGate = Completer<void>();
      await pumpDetail(tester, repository);

      expect(find.text('Memuat data pengemudi...'), findsOneWidget);
      expect(find.text('Belum ada pengemudi'), findsNothing);

      repository.currentDriverGate!.complete();
      await tester.pumpAndSettle();

      expect(find.text('Bambang Susanto'), findsOneWidget);
      expect(find.text('BS'), findsOneWidget);
      expect(find.text('Ganti Pengemudi'), findsOneWidget);
    },
  );

  testWidgets('gagal memuat pengemudi menampilkan pesan dan bisa dicoba lagi', (
    tester,
  ) async {
    setScreen(tester, const Size(390, 844));
    final repository = FakeVehicleAssignmentRepository(currentDriver: bambang)
      ..currentDriverError = Exception('HTTP 500: Server Error');
    await pumpDetail(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text('Gagal memuat pengemudi'), findsOneWidget);
    expect(find.text('HTTP 500: Server Error'), findsOneWidget);

    repository.currentDriverError = null;
    await tester.tap(find.text('Coba Lagi'));
    await tester.pumpAndSettle();

    expect(find.text('Bambang Susanto'), findsOneWidget);
  });

  testWidgets(
    'setelah menugaskan, halaman detail langsung menampilkan pengemudi baru',
    (tester) async {
      setScreen(tester, const Size(390, 844));
      final repository = FakeVehicleAssignmentRepository(
        vehicles: [buildVehicle()],
        drivers: [agus],
      );
      await pumpDetail(tester, repository);
      await tester.pumpAndSettle();
      expect(find.text('Belum ada pengemudi'), findsOneWidget);

      await tester.tap(find.text('Tugaskan Pengemudi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Agus Hidayat'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Konfirmasi'));
      await tester.pumpAndSettle();

      expect(repository.assignments, [(1, 82)]);
      expect(find.text('Detail Kendaraan'), findsOneWidget);
      expect(find.text('Agus Hidayat'), findsOneWidget);
      expect(find.text('Ganti Pengemudi'), findsOneWidget);
      expect(find.text('Belum ada pengemudi'), findsNothing);
      expect(find.text('Pengemudi berhasil ditugaskan'), findsOneWidget);

      // Biarkan timer snackbar selesai sebelum test berakhir.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
  );

  testWidgets('kembali tanpa menugaskan tidak menghapus pengemudi saat ini', (
    tester,
  ) async {
    setScreen(tester, const Size(390, 844));
    await pumpDetail(
      tester,
      FakeVehicleAssignmentRepository(currentDriver: bambang, drivers: [agus]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ganti Pengemudi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    expect(find.text('Bambang Susanto'), findsOneWidget);
    expect(find.text('Belum ada pengemudi'), findsNothing);
  });
}
