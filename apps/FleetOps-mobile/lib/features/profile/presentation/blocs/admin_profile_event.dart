import 'package:equatable/equatable.dart';

abstract class AdminProfileEvent extends Equatable {
  const AdminProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminProfileEvent extends AdminProfileEvent {
  const LoadAdminProfileEvent();
}
