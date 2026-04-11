package com.myguard.pet.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class VaccinationResponse {
    String id;
    String petId;
    String vaccineName;
    Instant dateAdministered;
    Instant nextDueDate;
    String vetName;
    String certificateUrl;
    Instant createdAt;
}
