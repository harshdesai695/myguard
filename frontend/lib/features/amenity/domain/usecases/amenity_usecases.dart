import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';
import 'package:myguard_frontend/features/amenity/domain/repositories/amenity_repository.dart';

class GetAmenitiesUseCase { const GetAmenitiesUseCase({required this.repository}); final AmenityRepository repository; Future<Either<Failure, PaginatedResponseModel<AmenityEntity>>> call({int page = 0, int size = 20, String? societyId}) => repository.getAmenities(page: page, size: size, societyId: societyId); }
class GetAmenitySlotsUseCase { const GetAmenitySlotsUseCase({required this.repository}); final AmenityRepository repository; Future<Either<Failure, List<BookingEntity>>> call(String amenityId, String date) => repository.getAmenitySlots(amenityId, date); }
class BookAmenityUseCase { const BookAmenityUseCase({required this.repository}); final AmenityRepository repository; Future<Either<Failure, BookingEntity>> call(Map<String, dynamic> data) => repository.bookAmenity(data); }
class GetMyBookingsUseCase { const GetMyBookingsUseCase({required this.repository}); final AmenityRepository repository; Future<Either<Failure, PaginatedResponseModel<BookingEntity>>> call({int page = 0, int size = 20}) => repository.getMyBookings(page: page, size: size); }
class CancelBookingUseCase { const CancelBookingUseCase({required this.repository}); final AmenityRepository repository; Future<Either<Failure, BookingEntity>> call(String id) => repository.cancelBooking(id); }
