package com.myguard.vehicle.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class VehicleResponse {
    String id;
    String plateNumber;
    String make;
    String model;
    String colour;
    String type;
    String ownerUid;
    String flatId;
    String parkingSlotId;
    String societyId;
    Instant createdAt;
}
