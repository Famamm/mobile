abstract class AdminVehicleListEvent {}

class LoadAdminVehicleList extends AdminVehicleListEvent {}

class DeleteAdminVehicle extends AdminVehicleListEvent {
  final int vehicleId;
  DeleteAdminVehicle({required this.vehicleId});
}
