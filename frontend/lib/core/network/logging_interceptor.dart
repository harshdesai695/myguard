import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌────────────────────────────────────────────');
      debugPrint('│ ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ Query: ${options.queryParameters}');
      }
      debugPrint('└────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('┌────────────────────────────────────────────');
      debugPrint(
        '│ ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri}',
      );
      debugPrint('│ Response: ${response.data}');
      debugPrint('└────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─── ERROR ──────────────────────────────────');
      debugPrint(
        '│ ${err.response?.statusCode} ${err.requestOptions.method} '
        '${err.requestOptions.uri}',
      );
      debugPrint('│ ${err.message}');
      debugPrint('└────────────────────────────────────────────');
    }
    handler.next(err);
  }
}
