package com.myguard.emergency.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreateEmergencyContactRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Phone is required")
    private String phone;

    @NotBlank(message = "Type is required")
    private String type;

    private String address;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
