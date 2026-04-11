import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/visitor/data/datasources/visitor_remote_datasource.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  const VisitorRepositoryImpl({required this.remoteDatasource});
  final VisitorRemoteDatasource remoteDatasource;

  @override
  Future<Either<Failure, PaginatedResponseModel<VisitorEntity>>> getVisitors({
    int page = 0,
    int size = 20,
    String? flatId,
    String? status,
    String? from,
    String? to,
  }) async {
    try {
      final result = await remoteDatasource.getVisitors(
        page: page, size: size, flatId: flatId, status: status, from: from, to: to,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VisitorEntity>> getVisitorById(String id) async {
    try {
      final result = await remoteDatasource.getVisitorById(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PreApprovalEntity>> preApproveVisitor({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
    int validHours = 24,
  }) async {
    try {
      final result = await remoteDatasource.preApproveVisitor({
        'visitorName': visitorName,
        'visitorPhone': visitorPhone,
        'purpose': purpose,
        'validHours': validHours,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<PreApprovalEntity>>>
      getPreApprovals({int page = 0, int size = 20}) async {
    try {
      final result = await remoteDatasource.getPreApprovals(page: page, size: size);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePreApproval(String id) async {
    try {
      await remoteDatasource.deletePreApproval(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VisitorEntity>> approveVisitor(String id) async {
    try {
      final result = await remoteDatasource.approveVisitor(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VisitorEntity>> rejectVisitor(String id) async {
    try {
      final result = await remoteDatasource.rejectVisitor(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VisitorEntity>> logVisitorEntry({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
    required String flatId,
    String? photoUrl,
    String? vehicleNumber,
    String? preApprovalId,
  }) async {
    try {
      final result = await remoteDatasource.logEntry({
        'visitorName': visitorName,
        'visitorPhone': visitorPhone,
        'purpose': purpose,
        'flatId': flatId,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
        if (preApprovalId != null) 'preApprovalId': preApprovalId,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VisitorEntity>> markVisitorExit(String id) async {
    try {
      final result = await remoteDatasource.markExit(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PreApprovalEntity>> verifyCode(String code) async {
    try {
      final result = await remoteDatasource.verifyCode(code);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PreApprovalEntity>> createGuestInvite({
    required String visitorName,
    required String visitorPhone,
    required String purpose,
  }) async {
    try {
      final result = await remoteDatasource.createGuestInvite({
        'visitorName': visitorName,
        'visitorPhone': visitorPhone,
        'purpose': purpose,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _mapError(DioException e) {
    final error = e.error;
    if (error is NetworkException) return const NetworkFailure();
    if (error is UnauthorizedException) return const UnauthorizedFailure();
    if (error is NotFoundException) return const NotFoundFailure();
    if (error is ServerException) return ServerFailure(error.message ?? 'Server error');
    return const UnknownFailure();
  }
}
