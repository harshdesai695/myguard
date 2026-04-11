package com.myguard.pet.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /pet_directory/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PetEntity {
    private String id;
    private String name;
    private String breed;
    private String type;
    private int age;
    private String photoUrl;
    private String ownerUid;
    private String flatId;
    private String vaccinationStatus;
    private String societyId;
    private Instant createdAt;
}
