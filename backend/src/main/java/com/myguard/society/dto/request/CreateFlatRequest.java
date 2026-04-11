package com.myguard.society.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreateFlatRequest {

    @NotBlank(message = "Block/tower is required")
    private String block;

    @PositiveOrZero(message = "Floor must be zero or positive")
    private int floor;

    @NotBlank(message = "Flat number is required")
    private String flatNumber;

    @NotBlank(message = "Flat type is required")
    private String type;

    private String primaryResidentUid;
}
