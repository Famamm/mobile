import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/trip_history/domain/repositories/history_repository.dart';
import 'package:fleetops_mobile/features/trip_history/domain/entities/trip_history.dart';
import 'trip_history_event.dart';
import 'trip_history_state.dart';

class TripHistoryBloc extends Bloc<TripHistoryEvent, TripHistoryState> {
  final HistoryRepository repository;

  TripHistoryBloc({required this.repository}) : super(TripHistoryInitial()) {
    on<LoadTripHistory>((event, emit) async {
      emit(TripHistoryLoading());
      try {
        final tripDtos = await repository.getTripHistory(event.driverId);

        final trips = tripDtos.map((dto) {
          final seconds = dto.durasi;
          final hours = seconds ~/ 3600;
          final minutes = (seconds % 3600) ~/ 60;
          final secs = seconds % 60;
          final durationFormatted =
              '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

          return TripHistory(
            tripId: dto.tripId,
            id: dto.tripId.toString(),
            startLocation: dto.lokasiAwal,
            endLocation: dto.lokasiAkhir,
            date: dto.waktuMulai,
            waktuSelesai: dto.waktuSelesai,
            jarak: '${dto.jarakTempuh} KM',
            durasi: durationFormatted,
            status: _mapStatusToIndonesian(dto.status),
            kecepatanRataRata: dto.avgSpeed != null
                ? '${dto.avgSpeed!.toStringAsFixed(1)} km/jam'
                : 'N/A',
            note: dto.catatan ?? '',
            driverName: '',
            konsumsiBBM: 'N/A',
          );
        }).toList();
        // Sort terbaru di atas berdasarkan waktuMulai descending
        trips.sort((a, b) => b.date.compareTo(a.date));
        emit(TripHistoryLoaded(trips));
      } catch (e) {
        final msg = e.toString();
        if (msg.contains('404') || msg.contains('No trips found')) {
          emit(TripHistoryLoaded([]));
        } else {
          emit(TripHistoryError("Gagal memuat riwayat: $msg"));
        }
      }
    });
  }

  String _mapStatusToIndonesian(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return 'Sedang Berjalan';
      case 'finished':
        return 'Selesai';
      case 'canceled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
