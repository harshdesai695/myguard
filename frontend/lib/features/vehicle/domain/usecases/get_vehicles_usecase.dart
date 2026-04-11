import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:myguard_frontend/features/vehicle/domain/repositories/vehicle_repository.dart';

class GetVehiclesUseCase { const GetVehiclesUseCase({required this.repository}); final VehicleRepository repository; Future<Either<Failure, PaginatedResponseModel<VehicleEntity>>> call({int page = 0, int size = 20}) => repository.getVehicles(page: page, size: size); }
