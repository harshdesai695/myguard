import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again later.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired. Please login again.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested resource was not found.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Please check your input and try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load cached data.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
