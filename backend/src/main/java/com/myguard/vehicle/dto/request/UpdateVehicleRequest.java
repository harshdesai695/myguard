package com.myguard.vehicle.dto.request;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateVehicleRequest {
    private String plateNumber;
    private String make;
    private String model;
    private String colour;
    private String type;
}
