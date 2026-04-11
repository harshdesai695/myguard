package com.myguard.vehicle.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class ParkingSlotResponse {
    String id;
    String slotNumber;
    String blockZone;
    String type;
    String allocatedVehicleId;
    String societyId;
    Instant createdAt;
}
