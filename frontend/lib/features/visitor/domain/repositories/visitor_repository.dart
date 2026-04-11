import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';

abstract class VisitorRepository {
  Future<Either<Failure, PaginatedResponseModel<VisitorEntity>>> getVisitors({
    int page = 0,
    int size = 20,
    String? flatId,
    String? status,
    String? from,
    String? to,
  });

  Future<Either<Failure, VisitorEntity>> getVisitorById(String id);

  Future<Either<Failure, PreApprovalEntity>> preApproveVisitor({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
    int validHours = 24,
  });

  Future<Either<Failure, PaginatedResponseModel<PreApprovalEntity>>>
      getPreApprovals({int page = 0, int size = 20});

  Future<Either<Failure, void>> deletePreApproval(String id);

  Future<Either<Failure, VisitorEntity>> approveVisitor(String id);

  Future<Either<Failure, VisitorEntity>> rejectVisitor(String id);

  Future<Either<Failure, VisitorEntity>> logVisitorEntry({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
    required String flatId,
    String? photoUrl,
    String? vehicleNumber,
    String? preApprovalId,
  });

  Future<Either<Failure, VisitorEntity>> markVisitorExit(String id);

  Future<Either<Failure, PreApprovalEntity>> verifyCode(String code);

  Future<Either<Failure, PreApprovalEntity>> createGuestInvite({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
  });
}
