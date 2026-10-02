class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message: message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message: message);
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message: message);
}
