import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/config/env_config.dart';
import 'package:myguard_frontend/core/network/auth_interceptor.dart';
import 'package:myguard_frontend/core/network/error_interceptor.dart';
import 'package:myguard_frontend/core/network/logging_interceptor.dart';

class DioClient {
  DioClient({required AuthInterceptor authInterceptor}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: EnvConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: EnvConfig.receiveTimeout),
        sendTimeout: const Duration(milliseconds: EnvConfig.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )
      ..interceptors.add(authInterceptor)
      ..interceptors.add(ErrorInterceptor())
      ..interceptors.add(LoggingInterceptor());
  }

  late final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
