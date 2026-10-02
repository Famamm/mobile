abstract class TripHistoryEvent {}

// Event untuk meminta data dimuat saat halaman dibuka
class LoadTripHistory extends TripHistoryEvent {
  final int driverId; // ID supir untuk mengambil riwayat yang sesuai

  LoadTripHistory({required this.driverId});
}
