package com.myguard.amenity.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CreateAmenityRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Type is required")
    private String type;

    @Min(value = 1, message = "Capacity must be at least 1")
    private int capacity;

    private double pricing;
    private String operatingHours;
    private int coolDownMinutes;
    private List<String> maintenanceClosureDates;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
