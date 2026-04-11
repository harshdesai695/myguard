package com.myguard.material.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;
import java.util.List;

@Data
@Builder
public class CreateGatepassRequest {

    @NotBlank(message = "Type is required")
    private String type;

    @NotBlank(message = "Description is required")
    private String description;

    @NotNull(message = "Items list is required")
    private List<String> items;

    private String vehicleNumber;
    private Instant expectedDate;

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
