package com.myguard.pet.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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
    private Object dateAdministered;
    private Object nextDueDate;
    private String vetName;
    private String certificateUrl;
    private Object createdAt;
}
