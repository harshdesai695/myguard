import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';

class GetVisitorsUseCase {
  const GetVisitorsUseCase({required this.repository});
  final VisitorRepository repository;

  Future<Either<Failure, PaginatedResponseModel<VisitorEntity>>> call({
    int page = 0,
    int size = 20,
    String? status,
  }) {
    return repository.getVisitors(page: page, size: size, status: status);
  }
}
