import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';

class RejectVisitorUseCase {
  const RejectVisitorUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, VisitorEntity>> call(String id) => repository.rejectVisitor(id);
}

class LogVisitorEntryUseCase {
  const LogVisitorEntryUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, VisitorEntity>> call({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
    required String flatId,
    String? photoUrl,
    String? vehicleNumber,
    String? preApprovalId,
  }) =>
      repository.logVisitorEntry(
        visitorName: visitorName,
        visitorPhone: visitorPhone,
        purpose: purpose,
        flatId: flatId,
        photoUrl: photoUrl,
        vehicleNumber: vehicleNumber,
        preApprovalId: preApprovalId,
      );
}

class MarkVisitorExitUseCase {
  const MarkVisitorExitUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, VisitorEntity>> call(String id) => repository.markVisitorExit(id);
}

class GetPreApprovalsUseCase {
  const GetPreApprovalsUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, PaginatedResponseModel<PreApprovalEntity>>> call({int page = 0, int size = 20}) =>
      repository.getPreApprovals(page: page, size: size);
}

class DeletePreApprovalUseCase {
  const DeletePreApprovalUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deletePreApproval(id);
}

class CreateGuestInviteUseCase {
  const CreateGuestInviteUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, PreApprovalEntity>> call({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
  }) =>
      repository.createGuestInvite(
        visitorName: visitorName,
        visitorPhone: visitorPhone,
        purpose: purpose,
      );
}

class VerifyVisitorCodeUseCase {
  const VerifyVisitorCodeUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, PreApprovalEntity>> call(String code) => repository.verifyCode(code);
}

class GetVisitorByIdUseCase {
  const GetVisitorByIdUseCase({required this.repository});
  final VisitorRepository repository;
  Future<Either<Failure, VisitorEntity>> call(String id) => repository.getVisitorById(id);
}
