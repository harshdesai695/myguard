import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';

class PreApproveVisitorUseCase {
  const PreApproveVisitorUseCase({required this.repository});
  final VisitorRepository repository;

  Future<Either<Failure, PreApprovalEntity>> call({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
    int validHours = 24,
  }) {
    return repository.preApproveVisitor(
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      purpose: purpose,
      validHours: validHours,
    );
  }
}
