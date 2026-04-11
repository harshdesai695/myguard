import 'package:dartz/dartz.dart'; import 'package:myguard_frontend/core/error/failures.dart'; import 'package:myguard_frontend/core/network/paginated_response_model.dart'; import 'package:myguard_frontend/features/society/domain/entities/society_entity.dart';

abstract class SocietyRepository {
  Future<Either<Failure, PaginatedResponseModel<SocietyEntity>>> getSocieties({int page, int size});
  Future<Either<Failure, SocietyEntity>> getSocietyById(String id);
  Future<Either<Failure, SocietyEntity>> createSociety(Map<String, dynamic> data);
  Future<Either<Failure, SocietyEntity>> updateSociety(String id, Map<String, dynamic> data);
  Future<Either<Failure, PaginatedResponseModel<FlatEntity>>> getFlats(String societyId, {int page, int size});
  Future<Either<Failure, FlatEntity>> createFlat(String societyId, Map<String, dynamic> data);
  Future<Either<Failure, FlatEntity>> updateFlat(String societyId, String flatId, Map<String, dynamic> data);
}
