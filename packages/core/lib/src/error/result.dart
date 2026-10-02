/// Simple Result pattern tanpa dartz package
/// Gunakan ini sampai package dartz diinstall

abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}

/// Helper extension
extension ResultExtension<T> on Result<T> {
  R fold<R>(R Function(String error) onError, R Function(T data) onSuccess) {
    if (this is Error<T>) {
      return onError((this as Error<T>).message);
    } else if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    }
    throw UnimplementedError();
  }

  bool isSuccess() => this is Success<T>;
  bool isError() => this is Error<T>;

  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  String? getErrorOrNull() {
    if (this is Error<T>) {
      return (this as Error<T>).message;
    }
    return null;
  }
}
