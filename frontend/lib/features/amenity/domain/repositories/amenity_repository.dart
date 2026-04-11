import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';

abstract class AmenityRepository {
  Future<Either<Failure, PaginatedResponseModel<AmenityEntity>>> getAmenities({int page, int size, String? societyId});
  Future<Either<Failure, AmenityEntity>> getAmenityById(String id);
  Future<Either<Failure, List<BookingEntity>>> getAmenitySlots(String amenityId, String date);
  Future<Either<Failure, BookingEntity>> bookAmenity(Map<String, dynamic> data);
  Future<Either<Failure, PaginatedResponseModel<BookingEntity>>> getMyBookings({int page, int size});
  Future<Either<Failure, BookingEntity>> cancelBooking(String id);
  Future<Either<Failure, AmenityEntity>> createAmenity(Map<String, dynamic> data);
  Future<Either<Failure, AmenityEntity>> updateAmenity(String id, Map<String, dynamic> data);
}
