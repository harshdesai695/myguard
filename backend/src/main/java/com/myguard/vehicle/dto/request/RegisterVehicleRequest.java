package com.myguard.vehicle.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RegisterVehicleRequest {

    @NotBlank(message = "Plate number is required")
    private String plateNumber;

    @NotBlank(message = "Make is required")
    private String make;

    @NotBlank(message = "Model is required")
    private String model;

    private String colour;

    @NotBlank(message = "Type is required")
    private String type;

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
