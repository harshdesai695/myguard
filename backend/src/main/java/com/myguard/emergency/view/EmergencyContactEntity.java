package com.myguard.emergency.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /emergency_contacts/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmergencyContactEntity {
    private String id;
    private String name;
    private String phone;
    private String type;
    private String address;
    private String societyId;
    private Instant createdAt;
}
