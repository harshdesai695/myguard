package com.myguard.pet.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;

@Data
@Builder
public class AddVaccinationRequest {

    @NotBlank(message = "Vaccine name is required")
    private String vaccineName;

    @NotNull(message = "Date administered is required")
    private Instant dateAdministered;

    private Instant nextDueDate;
    private String vetName;
    private String certificateUrl;
}
