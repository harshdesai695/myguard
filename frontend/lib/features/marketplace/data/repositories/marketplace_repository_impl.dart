import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/marketplace/data/datasources/marketplace_remote_datasource.dart';
import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';
import 'package:myguard_frontend/features/marketplace/domain/repositories/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  const MarketplaceRepositoryImpl({required this.remoteDatasource}); final MarketplaceRemoteDatasource remoteDatasource;
  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }
  @override Future<Either<Failure, PaginatedResponseModel<ListingEntity>>> getListings({int page = 0, int size = 20, String? category, String? societyId}) async { try { return Right(await remoteDatasource.getListings(page: page, size: size, category: category, societyId: societyId)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, ListingEntity>> getListingById(String id) async { try { return Right(await remoteDatasource.getListingById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, ListingEntity>> createListing(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createListing(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, ListingEntity>> updateListing(String id, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.updateListing(id, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, void>> deleteListing(String id) async { try { await remoteDatasource.deleteListing(id); return const Right(null); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, ListingEntity>> markSold(String id) async { try { return Right(await remoteDatasource.markSold(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, void>> expressInterest(String listingId, Map<String, dynamic> data) async { try { await remoteDatasource.expressInterest(listingId, data); return const Right(null); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}
