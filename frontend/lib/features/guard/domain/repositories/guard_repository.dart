import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';

abstract class GuardRepository {
  Future<Either<Failure, PaginatedResponseModel<CheckpointEntity>>> getCheckpoints({int page, int size});
  Future<Either<Failure, PatrolEntity>> logPatrol({required String checkpointId, String? notes, required String societyId});
  Future<Either<Failure, PaginatedResponseModel<PatrolEntity>>> getPatrols({int page, int size, String? guardUid});
  Future<Either<Failure, PaginatedResponseModel<ShiftEntity>>> getShifts({int page, int size});
  Future<Either<Failure, ShiftEntity>> createShift(Map<String, dynamic> data);
  Future<Either<Failure, void>> sendIntercom(String flatId, Map<String, dynamic> data);
}
