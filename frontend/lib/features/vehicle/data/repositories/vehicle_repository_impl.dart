import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:myguard_frontend/features/vehicle/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl({required this.remoteDatasource});
  final VehicleRemoteDatasource remoteDatasource;
  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }

  @override Future<Either<Failure, PaginatedResponseModel<VehicleEntity>>> getVehicles({int page = 0, int size = 20}) async { try { return Right(await remoteDatasource.getVehicles(page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, VehicleEntity>> getVehicleById(String id) async { try { return Right(await remoteDatasource.getVehicleById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, VehicleEntity>> registerVehicle(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.registerVehicle(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, VehicleEntity>> updateVehicle(String id, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.updateVehicle(id, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, void>> deleteVehicle(String id) async { try { await remoteDatasource.deleteVehicle(id); return const Right(null); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, VehicleEntity>> lookupByPlate(String plateNumber) async { try { return Right(await remoteDatasource.lookupByPlate(plateNumber)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}
