import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/amenity/data/datasources/amenity_remote_datasource.dart';
import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';
import 'package:myguard_frontend/features/amenity/domain/repositories/amenity_repository.dart';

class AmenityRepositoryImpl implements AmenityRepository {
  const AmenityRepositoryImpl({required this.remoteDatasource});
  final AmenityRemoteDatasource remoteDatasource;
  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }

  @override Future<Either<Failure, PaginatedResponseModel<AmenityEntity>>> getAmenities({int page = 0, int size = 20, String? societyId}) async { try { return Right(await remoteDatasource.getAmenities(page: page, size: size, societyId: societyId)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, AmenityEntity>> getAmenityById(String id) async { try { return Right(await remoteDatasource.getAmenityById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, List<BookingEntity>>> getAmenitySlots(String amenityId, String date) async { try { return Right(await remoteDatasource.getAmenitySlots(amenityId, date)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, BookingEntity>> bookAmenity(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.bookAmenity(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<BookingEntity>>> getMyBookings({int page = 0, int size = 20}) async { try { return Right(await remoteDatasource.getMyBookings(page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, BookingEntity>> cancelBooking(String id) async { try { return Right(await remoteDatasource.cancelBooking(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, AmenityEntity>> createAmenity(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createAmenity(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, AmenityEntity>> updateAmenity(String id, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.updateAmenity(id, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<BookingEntity>>> getAdminBookings({int page = 0, int size = 20}) async { try { return Right(await remoteDatasource.getAdminBookings(page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}
