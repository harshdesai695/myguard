package com.myguard.amenity.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class AmenityResponse {
    String id;
    String name;
    String type;
    int capacity;
    double pricing;
    String operatingHours;
    int coolDownMinutes;
    List<String> maintenanceClosureDates;
    String societyId;
    String status;
    Instant createdAt;
    Instant updatedAt;
}
