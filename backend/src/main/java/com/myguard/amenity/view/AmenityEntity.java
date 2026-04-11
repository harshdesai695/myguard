package com.myguard.amenity.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /amenities/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AmenityEntity {
    private String id;
    private String name;
    private String type;
    private int capacity;
    private double pricing;
    private String operatingHours;
    private int coolDownMinutes;
    private List<String> maintenanceClosureDates;
    private String societyId;
    private String status;
    private Instant createdAt;
    private Instant updatedAt;
}
