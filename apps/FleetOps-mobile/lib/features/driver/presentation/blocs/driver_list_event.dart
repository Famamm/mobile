abstract class DriverListEvent {}

class LoadDriverList extends DriverListEvent {}

class DeleteDriver extends DriverListEvent {
  final int driverId;
  DeleteDriver({required this.driverId});
}
