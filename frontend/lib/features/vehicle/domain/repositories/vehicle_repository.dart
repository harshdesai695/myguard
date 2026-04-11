import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<Either<Failure, PaginatedResponseModel<VehicleEntity>>> getVehicles({int page, int size});
  Future<Either<Failure, VehicleEntity>> getVehicleById(String id);
  Future<Either<Failure, VehicleEntity>> registerVehicle(Map<String, dynamic> data);
  Future<Either<Failure, VehicleEntity>> updateVehicle(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteVehicle(String id);
  Future<Either<Failure, VehicleEntity>> lookupByPlate(String plateNumber);
}
