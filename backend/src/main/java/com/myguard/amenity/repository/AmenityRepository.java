package com.myguard.amenity.repository;

import com.myguard.amenity.view.AmenityEntity;
import com.myguard.amenity.view.BookingEntity;

import java.util.List;
import java.util.Optional;

public interface AmenityRepository {
    AmenityEntity saveAmenity(AmenityEntity amenity);
    Optional<AmenityEntity> findAmenityById(String id);
    AmenityEntity updateAmenity(AmenityEntity amenity);
    List<AmenityEntity> findAmenities(String societyId, int page, int size);
    long countAmenities(String societyId);

    BookingEntity saveBooking(BookingEntity booking);
    Optional<BookingEntity> findBookingById(String id);
    BookingEntity updateBooking(BookingEntity booking);
    List<BookingEntity> findBookingsByResident(String residentUid, int page, int size);
    long countBookingsByResident(String residentUid);
    List<BookingEntity> findBookingsByAmenityAndDate(String amenityId, String date);
    List<BookingEntity> findAllBookings(int page, int size);
    long countAllBookings();
}
