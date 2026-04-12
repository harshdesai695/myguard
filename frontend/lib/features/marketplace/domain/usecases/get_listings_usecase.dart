import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';
import 'package:myguard_frontend/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetListingsUseCase { const GetListingsUseCase({required this.repository}); final MarketplaceRepository repository; Future<Either<Failure, PaginatedResponseModel<ListingEntity>>> call({int page = 0, int size = 20, String? category, String? societyId}) => repository.getListings(page: page, size: size, category: category, societyId: societyId); }
