abstract class FleetManagerDetailEvent {}

class LoadFleetManagerDetail extends FleetManagerDetailEvent {
  final int userId;
  LoadFleetManagerDetail(this.userId);
}

class DeleteFleetManager extends FleetManagerDetailEvent {
  final int userId;
  DeleteFleetManager(this.userId);
}

class ResetFleetManagerPassword extends FleetManagerDetailEvent {
  final int userId;
  ResetFleetManagerPassword(this.userId);
}
