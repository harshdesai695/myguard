package com.myguard.guard.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data @Builder
public class CreateCheckpointRequest {
    @NotBlank(message = "Name is required") private String name;
    private String description;
    @NotBlank(message = "Society ID is required") private String societyId;
    private double latitude;
    private double longitude;
    private String qrCode;
}
