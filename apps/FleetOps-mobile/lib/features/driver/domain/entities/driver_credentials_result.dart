import 'driver.dart';

class DriverCredentialsResult {
  final Driver driver;
  final String? username;
  final String? password;

  DriverCredentialsResult({
    required this.driver,
    this.username,
    this.password,
  });
}
