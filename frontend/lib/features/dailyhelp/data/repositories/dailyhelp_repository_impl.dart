import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/dailyhelp/data/datasources/dailyhelp_remote_datasource.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/repositories/dailyhelp_repository.dart';

class DailyHelpRepositoryImpl implements DailyHelpRepository {
  const DailyHelpRepositoryImpl({required this.remoteDatasource});
  final DailyHelpRemoteDatasource remoteDatasource;

  @override
  Future<Either<Failure, PaginatedResponseModel<DailyHelpEntity>>> getDailyHelps({int page = 0, int size = 20}) async {
    try { return Right(await remoteDatasource.getDailyHelps(page: page, size: size)); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, DailyHelpEntity>> getDailyHelpById(String id) async {
    try { return Right(await remoteDatasource.getDailyHelpById(id)); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, DailyHelpEntity>> createDailyHelp(Map<String, dynamic> data) async {
    try { return Right(await remoteDatasource.createDailyHelp(data)); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, DailyHelpEntity>> updateDailyHelp(String id, Map<String, dynamic> data) async {
    try { return Right(await remoteDatasource.updateDailyHelp(id, data)); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, void>> deleteDailyHelp(String id) async {
    try { await remoteDatasource.deleteDailyHelp(id); return const Right(null); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, AttendanceEntity>> markAttendance(String dailyHelpId) async {
    try { return Right(await remoteDatasource.markAttendance(dailyHelpId)); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<AttendanceEntity>>> getAttendance(String dailyHelpId, {int page = 0, int size = 20}) async {
    try { return Right(await remoteDatasource.getAttendance(dailyHelpId, page: page, size: size)); }
    on DioException catch (e) { return Left(_map(e)); }
    catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  Failure _map(DioException e) {
    final error = e.error;
    if (error is NetworkException) return const NetworkFailure();
    if (error is UnauthorizedException) return const UnauthorizedFailure();
    if (error is ServerException) return ServerFailure(error.message ?? 'Server error');
    return const UnknownFailure();
  }
}
