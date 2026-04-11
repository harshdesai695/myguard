package com.myguard.amenity.service;

import com.myguard.amenity.dto.request.CreateAmenityRequest;
import com.myguard.amenity.dto.request.CreateBookingRequest;
import com.myguard.amenity.dto.request.UpdateAmenityRequest;
import com.myguard.amenity.dto.response.AmenityResponse;
import com.myguard.amenity.dto.response.BookingResponse;
import com.myguard.common.response.PaginatedResponse;

import java.util.List;

public interface AmenityService {
    AmenityResponse createAmenity(CreateAmenityRequest request);
    PaginatedResponse<AmenityResponse> listAmenities(int page, int size, String societyId);
    AmenityResponse getAmenityById(String id);
    AmenityResponse updateAmenity(String id, UpdateAmenityRequest request);
    List<BookingResponse> getAvailableSlots(String amenityId, String date);

    BookingResponse createBooking(CreateBookingRequest request);
    PaginatedResponse<BookingResponse> listMyBookings(int page, int size);
    BookingResponse getBookingById(String id);
    BookingResponse cancelBooking(String id);
    BookingResponse checkIn(String id);
    BookingResponse checkOut(String id);
    PaginatedResponse<BookingResponse> listAllBookings(int page, int size);
}
