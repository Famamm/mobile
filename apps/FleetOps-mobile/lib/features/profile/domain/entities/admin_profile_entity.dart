import 'package:equatable/equatable.dart';

class AdminProfileEntity extends Equatable {
  final String nama;
  final String? username;
  final String email;
  final String? alamat;
  final String? photoUrl;
  final String? role;

  const AdminProfileEntity({
    required this.nama,
    this.username,
    required this.email,
    this.alamat,
    this.photoUrl,
    this.role,
  });

  @override
  List<Object?> get props => [nama, username, email, alamat, photoUrl, role];
}
