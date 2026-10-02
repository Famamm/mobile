import 'package:equatable/equatable.dart';

import '../../domain/entities/admin_profile_entity.dart';

abstract class AdminProfileState extends Equatable {
  const AdminProfileState();

  @override
  List<Object> get props => [];
}

class AdminProfileInitial extends AdminProfileState {
  const AdminProfileInitial();
}

class AdminProfileLoading extends AdminProfileState {
  const AdminProfileLoading();
}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileEntity entity;

  const AdminProfileLoaded(this.entity);

  @override
  List<Object> get props => [entity];
}

class AdminProfileError extends AdminProfileState {
  final String message;

  const AdminProfileError(this.message);

  @override
  List<Object> get props => [message];
}
