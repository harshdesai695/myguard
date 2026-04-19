import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';
import 'package:myguard_frontend/features/marketplace/domain/repositories/marketplace_repository.dart';

class CreateListingUseCase {
  const CreateListingUseCase({required this.repository});
  final MarketplaceRepository repository;
  Future<Either<Failure, ListingEntity>> call(Map<String, dynamic> data) => repository.createListing(data);
}

class UpdateListingUseCase {
  const UpdateListingUseCase({required this.repository});
  final MarketplaceRepository repository;
  Future<Either<Failure, ListingEntity>> call(String id, Map<String, dynamic> data) =>
      repository.updateListing(id, data);
}

class DeleteListingUseCase {
  const DeleteListingUseCase({required this.repository});
  final MarketplaceRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deleteListing(id);
}

class MarkSoldUseCase {
  const MarkSoldUseCase({required this.repository});
  final MarketplaceRepository repository;
  Future<Either<Failure, ListingEntity>> call(String id) => repository.markSold(id);
}

class ExpressInterestUseCase {
  const ExpressInterestUseCase({required this.repository});
  final MarketplaceRepository repository;
  Future<Either<Failure, void>> call(String listingId, Map<String, dynamic> data) =>
      repository.expressInterest(listingId, data);
}
