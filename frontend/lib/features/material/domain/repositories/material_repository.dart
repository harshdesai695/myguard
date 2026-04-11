import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/material/domain/entities/material_entity.dart';

abstract class MaterialRepository {
  Future<Either<Failure, PaginatedResponseModel<GatepassEntity>>> getGatepasses({int page, int size});
  Future<Either<Failure, GatepassEntity>> getGatepassById(String id);
  Future<Either<Failure, GatepassEntity>> createGatepass(Map<String, dynamic> data);
  Future<Either<Failure, GatepassEntity>> approveGatepass(String id);
  Future<Either<Failure, GatepassEntity>> verifyGatepass(String id);
}
