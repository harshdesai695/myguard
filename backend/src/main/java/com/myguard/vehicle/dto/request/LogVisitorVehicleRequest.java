package com.myguard.vehicle.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LogVisitorVehicleRequest {

    @NotBlank(message = "Plate number is required")
    private String plateNumber;

    private String visitorEntryId;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
