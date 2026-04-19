import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';
import 'package:myguard_frontend/features/guard/domain/repositories/guard_repository.dart';

class GetShiftsUseCase {
  const GetShiftsUseCase({required this.repository});
  final GuardRepository repository;
  Future<Either<Failure, PaginatedResponseModel<ShiftEntity>>> call({int page = 0, int size = 20}) =>
      repository.getShifts(page: page, size: size);
}

class CreateShiftUseCase {
  const CreateShiftUseCase({required this.repository});
  final GuardRepository repository;
  Future<Either<Failure, ShiftEntity>> call(Map<String, dynamic> data) => repository.createShift(data);
}

class SendIntercomUseCase {
  const SendIntercomUseCase({required this.repository});
  final GuardRepository repository;
  Future<Either<Failure, void>> call(String flatId, Map<String, dynamic> data) =>
      repository.sendIntercom(flatId, data);
}

class GetPatrolsUseCase {
  const GetPatrolsUseCase({required this.repository});
  final GuardRepository repository;
  Future<Either<Failure, PaginatedResponseModel<PatrolEntity>>> call({int page = 0, int size = 20, String? guardUid}) =>
      repository.getPatrols(page: page, size: size, guardUid: guardUid);
}
