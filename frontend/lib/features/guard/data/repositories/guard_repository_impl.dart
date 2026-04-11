import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/guard/data/datasources/guard_remote_datasource.dart';
import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';
import 'package:myguard_frontend/features/guard/domain/repositories/guard_repository.dart';

class GuardRepositoryImpl implements GuardRepository {
  const GuardRepositoryImpl({required this.remoteDatasource});
  final GuardRemoteDatasource remoteDatasource;

  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }

  @override
  Future<Either<Failure, PaginatedResponseModel<CheckpointEntity>>> getCheckpoints({int page = 0, int size = 20}) async {
    try { return Right(await remoteDatasource.getCheckpoints(page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, PatrolEntity>> logPatrol({required String checkpointId, String? notes, required String societyId}) async {
    try { return Right(await remoteDatasource.logPatrol({'checkpointId': checkpointId, if (notes != null) 'notes': notes, 'societyId': societyId})); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<PatrolEntity>>> getPatrols({int page = 0, int size = 20, String? guardUid}) async {
    try { return Right(await remoteDatasource.getPatrols(page: page, size: size, guardUid: guardUid)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<ShiftEntity>>> getShifts({int page = 0, int size = 20}) async {
    try { return Right(await remoteDatasource.getShifts(page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, ShiftEntity>> createShift(Map<String, dynamic> data) async {
    try { return Right(await remoteDatasource.createShift(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, void>> sendIntercom(String flatId, Map<String, dynamic> data) async {
    try { await remoteDatasource.sendIntercom(flatId, data); return const Right(null); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); }
  }
}
