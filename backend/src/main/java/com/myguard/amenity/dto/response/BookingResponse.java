package com.myguard.amenity.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class BookingResponse {
    String id;
    String amenityId;
    String residentUid;
    String flatId;
    String slotDate;
    String slotStartTime;
    String slotEndTime;
    int companions;
    String status;
    String societyId;
    Instant createdAt;
    Instant updatedAt;
}
