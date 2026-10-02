abstract class DriverDetailEvent {}

class LoadDriverDetail extends DriverDetailEvent {
  final int driverId;

  LoadDriverDetail(this.driverId);
}

class DeleteDriverFromDetail extends DriverDetailEvent {
  final int driverId;
  DeleteDriverFromDetail(this.driverId);
}
