import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';
import 'package:myguard_frontend/features/amenity/domain/repositories/amenity_repository.dart';
import 'package:myguard_frontend/features/amenity/domain/usecases/amenity_usecases.dart';

sealed class AmenityEvent extends Equatable { const AmenityEvent(); @override List<Object?> get props => []; }
class AmenitiesFetched extends AmenityEvent { const AmenitiesFetched({this.page = 0}); final int page; @override List<Object> get props => [page]; }
class AmenitySlotsFetched extends AmenityEvent { const AmenitySlotsFetched({required this.amenityId, required this.date}); final String amenityId; final String date; @override List<Object> get props => [amenityId, date]; }
class AmenityBooked extends AmenityEvent { const AmenityBooked(this.data); final Map<String, dynamic> data; @override List<Object> get props => [data]; }
class MyBookingsFetched extends AmenityEvent { const MyBookingsFetched({this.page = 0}); final int page; @override List<Object> get props => [page]; }
class BookingCancelled extends AmenityEvent { const BookingCancelled(this.id); final String id; @override List<Object> get props => [id]; }
class AmenityCreated extends AmenityEvent { const AmenityCreated(this.data); final Map<String, dynamic> data; @override List<Object> get props => [data]; }
class AmenityUpdated extends AmenityEvent { const AmenityUpdated({required this.id, required this.data}); final String id; final Map<String, dynamic> data; @override List<Object> get props => [id, data]; }
class AdminBookingsFetched extends AmenityEvent { const AdminBookingsFetched({this.page = 0}); final int page; @override List<Object> get props => [page]; }

sealed class AmenityState extends Equatable { const AmenityState(); @override List<Object?> get props => []; }
class AmenityInitial extends AmenityState { const AmenityInitial(); }
class AmenityLoading extends AmenityState { const AmenityLoading(); }
class AmenitiesLoaded extends AmenityState { const AmenitiesLoaded({required this.amenities, required this.hasMore, required this.page}); final List<AmenityEntity> amenities; final bool hasMore; final int page; @override List<Object> get props => [amenities, hasMore, page]; }
class AmenitySlotsLoaded extends AmenityState { const AmenitySlotsLoaded(this.slots); final List<BookingEntity> slots; @override List<Object> get props => [slots]; }
class BookingsLoaded extends AmenityState { const BookingsLoaded({required this.bookings, required this.hasMore}); final List<BookingEntity> bookings; final bool hasMore; @override List<Object> get props => [bookings, hasMore]; }
class AmenityActionSuccess extends AmenityState { const AmenityActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class AmenityError extends AmenityState { const AmenityError(this.message); final String message; @override List<Object> get props => [message]; }

class AmenityBloc extends Bloc<AmenityEvent, AmenityState> {
  AmenityBloc({required GetAmenitiesUseCase getAmenitiesUseCase, required GetAmenitySlotsUseCase getAmenitySlotsUseCase, required BookAmenityUseCase bookAmenityUseCase, required GetMyBookingsUseCase getMyBookingsUseCase, required CancelBookingUseCase cancelBookingUseCase, required AmenityRepository repository}) : _getAmenitiesUseCase = getAmenitiesUseCase, _getAmenitySlotsUseCase = getAmenitySlotsUseCase, _bookAmenityUseCase = bookAmenityUseCase, _getMyBookingsUseCase = getMyBookingsUseCase, _cancelBookingUseCase = cancelBookingUseCase, _repository = repository, super(const AmenityInitial()) {
    on<AmenitiesFetched>(_onFetched); on<AmenitySlotsFetched>(_onSlots); on<AmenityBooked>(_onBooked); on<MyBookingsFetched>(_onMyBookings); on<BookingCancelled>(_onCancelled); on<AmenityCreated>(_onCreated); on<AmenityUpdated>(_onUpdated); on<AdminBookingsFetched>(_onAdminBookings);
  }
  final GetAmenitiesUseCase _getAmenitiesUseCase; final GetAmenitySlotsUseCase _getAmenitySlotsUseCase; final BookAmenityUseCase _bookAmenityUseCase; final GetMyBookingsUseCase _getMyBookingsUseCase; final CancelBookingUseCase _cancelBookingUseCase; final AmenityRepository _repository;
  final List<AmenityEntity> _amenities = []; final List<BookingEntity> _bookings = [];

  Future<void> _onFetched(AmenitiesFetched e, Emitter<AmenityState> emit) async { if (e.page == 0) { _amenities.clear(); emit(const AmenityLoading()); } final r = await _getAmenitiesUseCase(page: e.page); r.fold((f) => emit(AmenityError(f.message)), (p) { _amenities.addAll(p.content); emit(AmenitiesLoaded(amenities: List.unmodifiable(_amenities), hasMore: p.hasNext, page: p.page)); }); }
  Future<void> _onSlots(AmenitySlotsFetched e, Emitter<AmenityState> emit) async { emit(const AmenityLoading()); final r = await _getAmenitySlotsUseCase(e.amenityId, e.date); r.fold((f) => emit(AmenityError(f.message)), (s) => emit(AmenitySlotsLoaded(s))); }
  Future<void> _onBooked(AmenityBooked e, Emitter<AmenityState> emit) async { emit(const AmenityLoading()); final r = await _bookAmenityUseCase(e.data); r.fold((f) => emit(AmenityError(f.message)), (_) => emit(const AmenityActionSuccess('Booking confirmed'))); }
  Future<void> _onMyBookings(MyBookingsFetched e, Emitter<AmenityState> emit) async { if (e.page == 0) { _bookings.clear(); emit(const AmenityLoading()); } final r = await _getMyBookingsUseCase(page: e.page); r.fold((f) => emit(AmenityError(f.message)), (p) { _bookings.addAll(p.content); emit(BookingsLoaded(bookings: List.unmodifiable(_bookings), hasMore: p.hasNext)); }); }
  Future<void> _onCancelled(BookingCancelled e, Emitter<AmenityState> emit) async { final r = await _cancelBookingUseCase(e.id); r.fold((f) => emit(AmenityError(f.message)), (_) => emit(const AmenityActionSuccess('Booking cancelled'))); }
  Future<void> _onCreated(AmenityCreated e, Emitter<AmenityState> emit) async { emit(const AmenityLoading()); final r = await _repository.createAmenity(e.data); r.fold((f) => emit(AmenityError(f.message)), (_) => emit(const AmenityActionSuccess('Amenity created'))); }
  Future<void> _onUpdated(AmenityUpdated e, Emitter<AmenityState> emit) async { emit(const AmenityLoading()); final r = await _repository.updateAmenity(e.id, e.data); r.fold((f) => emit(AmenityError(f.message)), (_) => emit(const AmenityActionSuccess('Amenity updated'))); }
  Future<void> _onAdminBookings(AdminBookingsFetched e, Emitter<AmenityState> emit) async { if (e.page == 0) { _bookings.clear(); emit(const AmenityLoading()); } final r = await _repository.getAdminBookings(page: e.page); r.fold((f) => emit(AmenityError(f.message)), (p) { _bookings.addAll(p.content); emit(BookingsLoaded(bookings: List.unmodifiable(_bookings), hasMore: p.hasNext)); }); }
}
