class EnvConfig {
  const EnvConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const String apiVersion = '/api/v1';

  static String get baseUrl => '$apiBaseUrl$apiVersion';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
