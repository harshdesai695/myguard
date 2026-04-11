package com.myguard.amenity.dto.request;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class UpdateAmenityRequest {
    private String name;
    private String type;
    private Integer capacity;
    private Double pricing;
    private String operatingHours;
    private Integer coolDownMinutes;
    private List<String> maintenanceClosureDates;
    private String status;
}
