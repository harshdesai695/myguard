import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:myguard_frontend/features/vehicle/domain/repositories/vehicle_repository.dart';

class RegisterVehicleUseCase {
  const RegisterVehicleUseCase({required this.repository});
  final VehicleRepository repository;
  Future<Either<Failure, VehicleEntity>> call(Map<String, dynamic> data) => repository.registerVehicle(data);
}

class UpdateVehicleUseCase {
  const UpdateVehicleUseCase({required this.repository});
  final VehicleRepository repository;
  Future<Either<Failure, VehicleEntity>> call(String id, Map<String, dynamic> data) => repository.updateVehicle(id, data);
}

class DeleteVehicleUseCase {
  const DeleteVehicleUseCase({required this.repository});
  final VehicleRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deleteVehicle(id);
}

class LookupVehicleUseCase {
  const LookupVehicleUseCase({required this.repository});
  final VehicleRepository repository;
  Future<Either<Failure, VehicleEntity>> call(String plateNumber) => repository.lookupByPlate(plateNumber);
}
