package com.myguard.society.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreateSocietyRequest {

    @NotBlank(message = "Society name is required")
    private String name;

    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "City is required")
    private String city;

    @NotBlank(message = "State is required")
    private String state;

    @NotBlank(message = "Pincode is required")
    private String pincode;

    @Positive(message = "Total blocks must be positive")
    private int totalBlocks;

    @Positive(message = "Total flats count must be positive")
    private int totalFlats;

    private String logoUrl;
}
