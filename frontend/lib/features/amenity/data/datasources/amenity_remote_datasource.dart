import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/amenity/data/models/amenity_model.dart';

abstract class AmenityRemoteDatasource {
  Future<PaginatedResponseModel<AmenityModel>> getAmenities({int page, int size, String? societyId});
  Future<AmenityModel> getAmenityById(String id);
  Future<List<BookingModel>> getAmenitySlots(String amenityId, String date);
  Future<BookingModel> bookAmenity(Map<String, dynamic> data);
  Future<PaginatedResponseModel<BookingModel>> getMyBookings({int page, int size});
  Future<BookingModel> cancelBooking(String id);
  Future<AmenityModel> createAmenity(Map<String, dynamic> data);
  Future<AmenityModel> updateAmenity(String id, Map<String, dynamic> data);
  Future<PaginatedResponseModel<BookingModel>> getAdminBookings({int page, int size});
}

class AmenityRemoteDatasourceImpl implements AmenityRemoteDatasource {
  const AmenityRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override Future<PaginatedResponseModel<AmenityModel>> getAmenities({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/amenities', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => AmenityModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<AmenityModel> getAmenityById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/amenities/$id'); return AmenityModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<List<BookingModel>> getAmenitySlots(String amenityId, String date) async { final r = await dioClient.get<Map<String, dynamic>>('/amenities/$amenityId/slots', queryParameters: {'date': date}); final list = r.data!['data'] as List<dynamic>; return list.map((j) => BookingModel.fromJson(j as Map<String, dynamic>)).toList(); }
  @override Future<BookingModel> bookAmenity(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/amenities/bookings', data: data); return BookingModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<BookingModel>> getMyBookings({int page = 0, int size = 20}) async { final r = await dioClient.get<Map<String, dynamic>>('/amenities/bookings', queryParameters: {'page': page, 'size': size}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => BookingModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<BookingModel> cancelBooking(String id) async { final r = await dioClient.patch<Map<String, dynamic>>('/amenities/bookings/$id/cancel'); return BookingModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<AmenityModel> createAmenity(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/amenities', data: data); return AmenityModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<AmenityModel> updateAmenity(String id, Map<String, dynamic> data) async { final r = await dioClient.put<Map<String, dynamic>>('/amenities/$id', data: data); return AmenityModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<BookingModel>> getAdminBookings({int page = 0, int size = 20}) async { final r = await dioClient.get<Map<String, dynamic>>('/amenities/bookings/admin', queryParameters: {'page': page, 'size': size}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => BookingModel.fromJson(j! as Map<String, dynamic>)); }
}
