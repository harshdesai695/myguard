import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';
import 'package:myguard_frontend/features/guard/domain/repositories/guard_repository.dart';

class LogPatrolUseCase {
  const LogPatrolUseCase({required this.repository});
  final GuardRepository repository;
  Future<Either<Failure, PatrolEntity>> call({required String checkpointId, String? notes, required String societyId}) =>
      repository.logPatrol(checkpointId: checkpointId, notes: notes, societyId: societyId);
}
