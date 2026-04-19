package com.myguard.society.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


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
    private Object createdAt;
    private Object updatedAt;
}
