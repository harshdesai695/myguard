package com.myguard.amenity.service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.google.api.pathtemplate.ValidationException;
import com.myguard.amenity.constants.AmenityConstants;
import com.myguard.amenity.dto.request.CreateAmenityRequest;
import com.myguard.amenity.dto.request.CreateBookingRequest;
import com.myguard.amenity.dto.request.UpdateAmenityRequest;
import com.myguard.amenity.dto.response.AmenityResponse;
import com.myguard.amenity.dto.response.BookingResponse;
import com.myguard.amenity.repository.AmenityRepository;
import com.myguard.amenity.view.AmenityEntity;
import com.myguard.amenity.view.BookingEntity;
import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AmenityServiceImpl implements AmenityService {

    private final AmenityRepository amenityRepository;

    private String getCurrentUid() {
        return (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    @Override
    public AmenityResponse createAmenity(CreateAmenityRequest request) {
        log.info("[AMENITY] Creating amenity: {}", request.getName());

        AmenityEntity entity = AmenityEntity.builder()
                .name(request.getName())
                .type(request.getType())
                .capacity(request.getCapacity())
                .pricing(request.getPricing())
                .operatingHours(request.getOperatingHours())
                .coolDownMinutes(request.getCoolDownMinutes())
                .maintenanceClosureDates(request.getMaintenanceClosureDates())
                .societyId(request.getSocietyId())
                .status(AmenityConstants.STATUS_ACTIVE)
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        AmenityEntity saved = amenityRepository.saveAmenity(entity);
        log.info("[AMENITY] Amenity created with ID: {}", saved.getId());
        return mapToAmenityResponse(saved);
    }

    @Override
    public PaginatedResponse<AmenityResponse> listAmenities(int page, int size, String societyId) {
        List<AmenityEntity> amenities = amenityRepository.findAmenities(societyId, page, size);
        long total = amenityRepository.countAmenities(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<AmenityResponse> content = amenities.stream()
                .map(this::mapToAmenityResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<AmenityResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public AmenityResponse getAmenityById(String id) {
        AmenityEntity entity = amenityRepository.findAmenityById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Amenity not found"));
        return mapToAmenityResponse(entity);
    }

    @Override
    public AmenityResponse updateAmenity(String id, UpdateAmenityRequest request) {
        AmenityEntity entity = amenityRepository.findAmenityById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Amenity not found"));

        if (request.getName() != null) entity.setName(request.getName());
        if (request.getType() != null) entity.setType(request.getType());
        if (request.getCapacity() != null) entity.setCapacity(request.getCapacity());
        if (request.getPricing() != null) entity.setPricing(request.getPricing());
        if (request.getOperatingHours() != null) entity.setOperatingHours(request.getOperatingHours());
        if (request.getCoolDownMinutes() != null) entity.setCoolDownMinutes(request.getCoolDownMinutes());
        if (request.getMaintenanceClosureDates() != null) entity.setMaintenanceClosureDates(request.getMaintenanceClosureDates());
        if (request.getStatus() != null) entity.setStatus(request.getStatus());
        entity.setUpdatedAt(Instant.now().toString());

        AmenityEntity updated = amenityRepository.updateAmenity(entity);
        log.info("[AMENITY] Amenity updated: {}", id);
        return mapToAmenityResponse(updated);
    }

    @Override
    public List<BookingResponse> getAvailableSlots(String amenityId, String date) {
        amenityRepository.findAmenityById(amenityId)
                .orElseThrow(() -> new ResourceNotFoundException("Amenity not found"));

        List<BookingEntity> bookings = amenityRepository.findBookingsByAmenityAndDate(amenityId, date);
        return bookings.stream()
                .map(this::mapToBookingResponse)
                .collect(Collectors.toList());
    }

    @Override
    public BookingResponse createBooking(CreateBookingRequest request) {
        String uid = getCurrentUid();
        log.info("[AMENITY] Creating booking for amenity: {}", request.getAmenityId());

        AmenityEntity amenity = amenityRepository.findAmenityById(request.getAmenityId())
                .orElseThrow(() -> new ResourceNotFoundException("Amenity not found"));

        List<BookingEntity> existingBookings = amenityRepository.findBookingsByAmenityAndDate(
                request.getAmenityId(), request.getSlotDate());
        long activeCount = existingBookings.stream()
                .filter(b -> !AmenityConstants.BOOKING_CANCELLED.equals(b.getStatus()))
                .count();
        if (activeCount >= amenity.getCapacity()) {
            throw new ValidationException("Amenity is fully booked for the selected date/time");
        }

        BookingEntity entity = BookingEntity.builder()
                .amenityId(request.getAmenityId())
                .residentUid(uid)
                .flatId(request.getFlatId())
                .slotDate(request.getSlotDate())
                .slotStartTime(request.getSlotStartTime())
                .slotEndTime(request.getSlotEndTime())
                .companions(request.getCompanions())
                .status(AmenityConstants.BOOKING_CONFIRMED)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        BookingEntity saved = amenityRepository.saveBooking(entity);
        log.info("[AMENITY] Booking created with ID: {}", saved.getId());
        return mapToBookingResponse(saved);
    }

    @Override
    public PaginatedResponse<BookingResponse> listMyBookings(int page, int size) {
        String uid = getCurrentUid();
        List<BookingEntity> bookings = amenityRepository.findBookingsByResident(uid, page, size);
        long total = amenityRepository.countBookingsByResident(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<BookingResponse> content = bookings.stream()
                .map(this::mapToBookingResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<BookingResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public BookingResponse getBookingById(String id) {
        BookingEntity entity = amenityRepository.findBookingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
        return mapToBookingResponse(entity);
    }

    @Override
    public BookingResponse cancelBooking(String id) {
        String uid = getCurrentUid();
        BookingEntity entity = amenityRepository.findBookingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        if (!entity.getResidentUid().equals(uid)) {
            throw new ValidationException("You can only cancel your own bookings");
        }

        entity.setStatus(AmenityConstants.BOOKING_CANCELLED);
        entity.setUpdatedAt(Instant.now().toString());
        BookingEntity updated = amenityRepository.updateBooking(entity);
        log.info("[AMENITY] Booking cancelled: {}", id);
        return mapToBookingResponse(updated);
    }

    @Override
    public BookingResponse checkIn(String id) {
        BookingEntity entity = amenityRepository.findBookingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        if (!AmenityConstants.BOOKING_CONFIRMED.equals(entity.getStatus())) {
            throw new ValidationException("Booking must be in confirmed status for check-in");
        }

        entity.setStatus(AmenityConstants.BOOKING_CHECKED_IN);
        entity.setUpdatedAt(Instant.now().toString());
        BookingEntity updated = amenityRepository.updateBooking(entity);
        log.info("[AMENITY] Booking checked in: {}", id);
        return mapToBookingResponse(updated);
    }

    @Override
    public BookingResponse checkOut(String id) {
        BookingEntity entity = amenityRepository.findBookingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        if (!AmenityConstants.BOOKING_CHECKED_IN.equals(entity.getStatus())) {
            throw new ValidationException("Booking must be checked in before check-out");
        }

        entity.setStatus(AmenityConstants.BOOKING_CHECKED_OUT);
        entity.setUpdatedAt(Instant.now().toString());
        BookingEntity updated = amenityRepository.updateBooking(entity);
        log.info("[AMENITY] Booking checked out: {}", id);
        return mapToBookingResponse(updated);
    }

    @Override
    public PaginatedResponse<BookingResponse> listAllBookings(int page, int size) {
        List<BookingEntity> bookings = amenityRepository.findAllBookings(page, size);
        long total = amenityRepository.countAllBookings();
        int totalPages = (int) Math.ceil((double) total / size);

        List<BookingResponse> content = bookings.stream()
                .map(this::mapToBookingResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<BookingResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    private AmenityResponse mapToAmenityResponse(AmenityEntity entity) {
        return AmenityResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .type(entity.getType())
                .capacity(entity.getCapacity())
                .pricing(entity.getPricing())
                .operatingHours(entity.getOperatingHours())
                .coolDownMinutes(entity.getCoolDownMinutes())
                .maintenanceClosureDates(entity.getMaintenanceClosureDates())
                .societyId(entity.getSocietyId())
                .status(entity.getStatus())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private BookingResponse mapToBookingResponse(BookingEntity entity) {
        return BookingResponse.builder()
                .id(entity.getId())
                .amenityId(entity.getAmenityId())
                .residentUid(entity.getResidentUid())
                .flatId(entity.getFlatId())
                .slotDate(entity.getSlotDate())
                .slotStartTime(entity.getSlotStartTime())
                .slotEndTime(entity.getSlotEndTime())
                .companions(entity.getCompanions())
                .status(entity.getStatus())
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
