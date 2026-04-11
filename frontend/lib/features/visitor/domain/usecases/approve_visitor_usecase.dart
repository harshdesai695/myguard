import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';

class ApproveVisitorUseCase {
  const ApproveVisitorUseCase({required this.repository});
  final VisitorRepository repository;

  Future<Either<Failure, VisitorEntity>> call(String id) {
    return repository.approveVisitor(id);
  }
}
