import 'package:dartz/dartz.dart'; import 'package:myguard_frontend/core/error/failures.dart'; import 'package:myguard_frontend/core/network/paginated_response_model.dart'; import 'package:myguard_frontend/features/pet/domain/entities/pet_entity.dart';

abstract class PetRepository {
  Future<Either<Failure, PaginatedResponseModel<PetEntity>>> getPets({int page, int size, String? societyId});
  Future<Either<Failure, PetEntity>> getPetById(String id);
  Future<Either<Failure, PetEntity>> registerPet(Map<String, dynamic> data);
  Future<Either<Failure, PetEntity>> updatePet(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deletePet(String id);
  Future<Either<Failure, VaccinationEntity>> addVaccination(String petId, Map<String, dynamic> data);
  Future<Either<Failure, List<VaccinationEntity>>> getVaccinations(String petId);
}
