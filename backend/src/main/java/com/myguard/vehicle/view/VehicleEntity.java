package com.myguard.vehicle.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


/**
 * Firestore collection: /vehicles/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VehicleEntity {
    private String id;
    private String plateNumber;
    private String make;
    private String model;
    private String colour;
    private String type;
    private String ownerUid;
    private String flatId;
    private String parkingSlotId;
    private String societyId;
    private Object createdAt;
}
