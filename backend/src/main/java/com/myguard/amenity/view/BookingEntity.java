package com.myguard.amenity.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /amenity_bookings/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingEntity {
    private String id;
    private String amenityId;
    private String residentUid;
    private String flatId;
    private String slotDate;
    private String slotStartTime;
    private String slotEndTime;
    private int companions;
    private String status;
    private String societyId;
    private Instant createdAt;
    private Instant updatedAt;
}
