import 'dart:io';

import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException('Connection timed out'),
            type: err.type,
          ),
        );
        return;
      case DioExceptionType.badResponse:
        _handleBadResponse(err, handler);
        return;
      case DioExceptionType.cancel:
        handler.next(err);
        return;
      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: const NetworkException(),
              type: err.type,
            ),
          );
          return;
        }
        handler.next(err);
        return;
      default:
        handler.next(err);
    }
  }

  void _handleBadResponse(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;
    String? message;

    if (responseData is Map<String, dynamic>) {
      message = responseData['message'] as String?;
    }

    switch (statusCode) {
      case 401:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(message ?? 'Unauthorized'),
            type: err.type,
            response: err.response,
          ),
        );
      case 404:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: NotFoundException(message ?? 'Not found'),
            type: err.type,
            response: err.response,
          ),
        );
      default:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              message: message ?? 'Server error',
              statusCode: statusCode,
            ),
            type: err.type,
            response: err.response,
          ),
        );
    }
  }
}
