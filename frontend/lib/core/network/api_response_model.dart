class ApiResponseModel<T> {
  const ApiResponseModel({
    required this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  final bool success;
  final String? message;
  final T? data;
  final String? timestamp;
}
