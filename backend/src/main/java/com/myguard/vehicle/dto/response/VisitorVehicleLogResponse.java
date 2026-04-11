package com.myguard.vehicle.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class VisitorVehicleLogResponse {
    String id;
    String plateNumber;
    Instant entryTime;
    Instant exitTime;
    String visitorEntryId;
    String societyId;
    Instant createdAt;
}
