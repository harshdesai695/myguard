class PaginatedResponseModel<T> {
  const PaginatedResponseModel({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponseModel(
      content: (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      page: json['page'] as int,
      size: json['size'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );
  }

  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
