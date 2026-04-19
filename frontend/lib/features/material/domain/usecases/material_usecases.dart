import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/material/domain/entities/material_entity.dart';
import 'package:myguard_frontend/features/material/domain/repositories/material_repository.dart';

class CreateGatepassUseCase {
  const CreateGatepassUseCase({required this.repository});
  final MaterialRepository repository;
  Future<Either<Failure, GatepassEntity>> call(Map<String, dynamic> data) => repository.createGatepass(data);
}

class ApproveGatepassUseCase {
  const ApproveGatepassUseCase({required this.repository});
  final MaterialRepository repository;
  Future<Either<Failure, GatepassEntity>> call(String id) => repository.approveGatepass(id);
}

class VerifyGatepassUseCase {
  const VerifyGatepassUseCase({required this.repository});
  final MaterialRepository repository;
  Future<Either<Failure, GatepassEntity>> call(String id) => repository.verifyGatepass(id);
}
