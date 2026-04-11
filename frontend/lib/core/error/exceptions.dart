class ServerException implements Exception {
  const ServerException({this.message, this.statusCode});
  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);

  final String message;

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

class NotFoundException implements Exception {
  const NotFoundException([this.message = 'Not found']);

  final String message;

  @override
  String toString() => 'NotFoundException(message: $message)';
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache failure']);

  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}
