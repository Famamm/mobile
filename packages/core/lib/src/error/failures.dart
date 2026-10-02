abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  ValidationFailure({required String message}) : super(message: message);
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure({required String message}) : super(message: message);
}

class UnknownFailure extends Failure {
  UnknownFailure({required String message}) : super(message: message);
}
