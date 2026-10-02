import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class InspectionState extends Equatable {
  const InspectionState();

  @override
  List<Object?> get props => [];
}

class InspectionInitial extends InspectionState {
  const InspectionInitial();

  @override
  List<Object?> get props => [];
}

class InspectionLoading extends InspectionState {
  const InspectionLoading();

  @override
  List<Object?> get props => [];
}

class InspectionSuccess extends InspectionState {
  final String message;

  const InspectionSuccess({
    this.message = 'Inspeksi berhasil dikirim ke server',
  });

  @override
  List<Object?> get props => [message];
}

class InspectionError extends InspectionState {
  final Failure failure;

  const InspectionError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
