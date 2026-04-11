package com.myguard.pet.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /pet_vaccinations/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VaccinationEntity {
    private String id;
    private String petId;
    private String vaccineName;
    private Instant dateAdministered;
    private Instant nextDueDate;
    private String vetName;
    private String certificateUrl;
    private Instant createdAt;
}
