import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';

abstract class MarketplaceRepository {
  Future<Either<Failure, PaginatedResponseModel<ListingEntity>>> getListings({int page, int size, String? category, String? societyId});
  Future<Either<Failure, ListingEntity>> getListingById(String id);
  Future<Either<Failure, ListingEntity>> createListing(Map<String, dynamic> data);
  Future<Either<Failure, ListingEntity>> updateListing(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteListing(String id);
  Future<Either<Failure, ListingEntity>> markSold(String id);
  Future<Either<Failure, void>> expressInterest(String listingId, Map<String, dynamic> data);
}
