package com.myguard.amenity.controller;

import com.myguard.amenity.dto.request.CreateAmenityRequest;
import com.myguard.amenity.dto.request.CreateBookingRequest;
import com.myguard.amenity.dto.request.UpdateAmenityRequest;
import com.myguard.amenity.dto.response.AmenityResponse;
import com.myguard.amenity.dto.response.BookingResponse;
import com.myguard.amenity.service.AmenityService;
import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1/amenities")
@RequiredArgsConstructor
public class AmenityController {

    private final AmenityService amenityService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<AmenityResponse>> createAmenity(
            @Valid @RequestBody CreateAmenityRequest request) {
        AmenityResponse response = amenityService.createAmenity(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Amenity created"));
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<AmenityResponse>>> listAmenities(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<AmenityResponse> response = amenityService.listAmenities(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<AmenityResponse>> getAmenity(@PathVariable String id) {
        AmenityResponse response = amenityService.getAmenityById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<AmenityResponse>> updateAmenity(
            @PathVariable String id,
            @Valid @RequestBody UpdateAmenityRequest request) {
        AmenityResponse response = amenityService.updateAmenity(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Amenity updated"));
    }

    @GetMapping("/{id}/slots")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<List<BookingResponse>>> getAvailableSlots(
            @PathVariable String id,
            @RequestParam String date) {
        List<BookingResponse> response = amenityService.getAvailableSlots(id, date);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/bookings")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<BookingResponse>> createBooking(
            @Valid @RequestBody CreateBookingRequest request) {
        BookingResponse response = amenityService.createBooking(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Booking created"));
    }

    @GetMapping("/bookings")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<BookingResponse>>> listMyBookings(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<BookingResponse> response = amenityService.listMyBookings(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/bookings/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<BookingResponse>> getBooking(@PathVariable String id) {
        BookingResponse response = amenityService.getBookingById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/bookings/{id}/cancel")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<BookingResponse>> cancelBooking(@PathVariable String id) {
        BookingResponse response = amenityService.cancelBooking(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Booking cancelled"));
    }

    @PatchMapping("/bookings/{id}/check-in")
    @PreAuthorize("hasAnyRole('GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<BookingResponse>> checkIn(@PathVariable String id) {
        BookingResponse response = amenityService.checkIn(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Checked in"));
    }

    @PatchMapping("/bookings/{id}/check-out")
    @PreAuthorize("hasAnyRole('GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<BookingResponse>> checkOut(@PathVariable String id) {
        BookingResponse response = amenityService.checkOut(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Checked out"));
    }

    @GetMapping("/bookings/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<BookingResponse>>> listAllBookings(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<BookingResponse> response = amenityService.listAllBookings(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
