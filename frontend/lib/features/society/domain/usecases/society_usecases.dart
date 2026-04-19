import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/society/domain/entities/society_entity.dart';
import 'package:myguard_frontend/features/society/domain/repositories/society_repository.dart';

class CreateSocietyUseCase {
  const CreateSocietyUseCase({required this.repository});
  final SocietyRepository repository;
  Future<Either<Failure, SocietyEntity>> call(Map<String, dynamic> data) => repository.createSociety(data);
}

class UpdateSocietyUseCase {
  const UpdateSocietyUseCase({required this.repository});
  final SocietyRepository repository;
  Future<Either<Failure, SocietyEntity>> call(String id, Map<String, dynamic> data) =>
      repository.updateSociety(id, data);
}

class GetFlatsUseCase {
  const GetFlatsUseCase({required this.repository});
  final SocietyRepository repository;
  Future<Either<Failure, PaginatedResponseModel<FlatEntity>>> call(String societyId, {int page = 0, int size = 20}) =>
      repository.getFlats(societyId, page: page, size: size);
}

class CreateFlatUseCase {
  const CreateFlatUseCase({required this.repository});
  final SocietyRepository repository;
  Future<Either<Failure, FlatEntity>> call(String societyId, Map<String, dynamic> data) =>
      repository.createFlat(societyId, data);
}

class UpdateFlatUseCase {
  const UpdateFlatUseCase({required this.repository});
  final SocietyRepository repository;
  Future<Either<Failure, FlatEntity>> call(String societyId, String flatId, Map<String, dynamic> data) =>
      repository.updateFlat(societyId, flatId, data);
}
