import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/society/data/datasources/society_remote_datasource.dart';
import 'package:myguard_frontend/features/society/domain/entities/society_entity.dart';
import 'package:myguard_frontend/features/society/domain/repositories/society_repository.dart';

class SocietyRepositoryImpl implements SocietyRepository {
  const SocietyRepositoryImpl({required this.remoteDatasource}); final SocietyRemoteDatasource remoteDatasource;
  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }
  @override Future<Either<Failure, PaginatedResponseModel<SocietyEntity>>> getSocieties({int page = 0, int size = 20}) async { try { return Right(await remoteDatasource.getSocieties(page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, SocietyEntity>> getSocietyById(String id) async { try { return Right(await remoteDatasource.getSocietyById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, SocietyEntity>> createSociety(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createSociety(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, SocietyEntity>> updateSociety(String id, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.updateSociety(id, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<FlatEntity>>> getFlats(String societyId, {int page = 0, int size = 20}) async { try { return Right(await remoteDatasource.getFlats(societyId, page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, FlatEntity>> createFlat(String societyId, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createFlat(societyId, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, FlatEntity>> updateFlat(String societyId, String flatId, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.updateFlat(societyId, flatId, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}
