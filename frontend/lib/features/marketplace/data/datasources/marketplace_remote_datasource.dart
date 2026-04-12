import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/marketplace/data/models/marketplace_model.dart';

abstract class MarketplaceRemoteDatasource { Future<PaginatedResponseModel<ListingModel>> getListings({int page, int size, String? category, String? societyId}); Future<ListingModel> getListingById(String id); Future<ListingModel> createListing(Map<String, dynamic> data); Future<ListingModel> updateListing(String id, Map<String, dynamic> data); Future<void> deleteListing(String id); Future<ListingModel> markSold(String id); Future<void> expressInterest(String listingId, Map<String, dynamic> data); }

class MarketplaceRemoteDatasourceImpl implements MarketplaceRemoteDatasource {
  const MarketplaceRemoteDatasourceImpl({required this.dioClient}); final DioClient dioClient;
  @override Future<PaginatedResponseModel<ListingModel>> getListings({int page = 0, int size = 20, String? category, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/marketplace/listings', queryParameters: {'page': page, 'size': size, if (category != null) 'category': category, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => ListingModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<ListingModel> getListingById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/marketplace/listings/$id'); return ListingModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<ListingModel> createListing(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/marketplace/listings', data: data); return ListingModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<ListingModel> updateListing(String id, Map<String, dynamic> data) async { final r = await dioClient.put<Map<String, dynamic>>('/marketplace/listings/$id', data: data); return ListingModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> deleteListing(String id) async => dioClient.delete<void>('/marketplace/listings/$id');
  @override Future<ListingModel> markSold(String id) async { final r = await dioClient.patch<Map<String, dynamic>>('/marketplace/listings/$id/mark-sold'); return ListingModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> expressInterest(String listingId, Map<String, dynamic> data) async => dioClient.post<void>('/marketplace/listings/$listingId/interest', data: data);
}
