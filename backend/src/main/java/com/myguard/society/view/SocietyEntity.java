package com.myguard.society.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /societies/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SocietyEntity {
    private String id;
    private String name;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private int totalBlocks;
    private int totalFlats;
    private String logoUrl;
    private String status;
    private Instant createdAt;
    private Instant updatedAt;
}
