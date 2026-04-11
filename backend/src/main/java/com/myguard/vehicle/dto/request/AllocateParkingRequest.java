package com.myguard.vehicle.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AllocateParkingRequest {

    @NotBlank(message = "Slot number is required")
    private String slotNumber;

    @NotBlank(message = "Block/zone is required")
    private String blockZone;

    @NotBlank(message = "Type is required")
    private String type;

    private String allocatedVehicleId;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
