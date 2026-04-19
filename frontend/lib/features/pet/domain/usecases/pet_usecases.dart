import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/pet/domain/entities/pet_entity.dart';
import 'package:myguard_frontend/features/pet/domain/repositories/pet_repository.dart';

class RegisterPetUseCase {
  const RegisterPetUseCase({required this.repository});
  final PetRepository repository;
  Future<Either<Failure, PetEntity>> call(Map<String, dynamic> data) => repository.registerPet(data);
}

class UpdatePetUseCase {
  const UpdatePetUseCase({required this.repository});
  final PetRepository repository;
  Future<Either<Failure, PetEntity>> call(String id, Map<String, dynamic> data) => repository.updatePet(id, data);
}

class DeletePetUseCase {
  const DeletePetUseCase({required this.repository});
  final PetRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deletePet(id);
}

class AddVaccinationUseCase {
  const AddVaccinationUseCase({required this.repository});
  final PetRepository repository;
  Future<Either<Failure, VaccinationEntity>> call(String petId, Map<String, dynamic> data) =>
      repository.addVaccination(petId, data);
}

class GetVaccinationsUseCase {
  const GetVaccinationsUseCase({required this.repository});
  final PetRepository repository;
  Future<Either<Failure, List<VaccinationEntity>>> call(String petId) => repository.getVaccinations(petId);
}
