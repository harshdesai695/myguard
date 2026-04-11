import 'package:dartz/dartz.dart'; import 'package:dio/dio.dart'; import 'package:myguard_frontend/core/error/exceptions.dart'; import 'package:myguard_frontend/core/error/failures.dart'; import 'package:myguard_frontend/features/dashboard/data/datasources/dashboard_remote_datasource.dart'; import 'package:myguard_frontend/features/dashboard/domain/entities/dashboard_entity.dart'; import 'package:myguard_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({required this.remoteDatasource}); final DashboardRemoteDatasource remoteDatasource;
  @override Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary(String societyId) async { try { return Right(await remoteDatasource.getDashboardSummary(societyId)); } on DioException catch (e) { final er = e.error; if (er is NetworkException) return const Left(NetworkFailure()); if (er is ServerException) return Left(ServerFailure(er.message ?? 'Error')); return const Left(UnknownFailure()); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}
