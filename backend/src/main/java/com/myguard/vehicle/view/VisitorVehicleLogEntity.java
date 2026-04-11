package com.myguard.vehicle.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /visitor_vehicle_logs/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VisitorVehicleLogEntity {
    private String id;
    private String plateNumber;
    private Instant entryTime;
    private Instant exitTime;
    private String visitorEntryId;
    private String societyId;
    private Instant createdAt;
}
