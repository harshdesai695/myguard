import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';
import 'package:myguard_frontend/features/guard/domain/repositories/guard_repository.dart';

class GetCheckpointsUseCase {
  const GetCheckpointsUseCase({required this.repository});
  final GuardRepository repository;
  Future<Either<Failure, PaginatedResponseModel<CheckpointEntity>>> call({int page = 0, int size = 20}) =>
      repository.getCheckpoints(page: page, size: size);
}
