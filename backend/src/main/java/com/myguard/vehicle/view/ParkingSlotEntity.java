package com.myguard.vehicle.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /parking_slots/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParkingSlotEntity {
    private String id;
    private String slotNumber;
    private String blockZone;
    private String type;
    private String allocatedVehicleId;
    private String societyId;
    private Instant createdAt;
}
