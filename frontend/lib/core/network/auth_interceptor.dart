import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/firebase/auth_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authService.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _authService.signOut();
    }
    handler.next(err);
  }
}
