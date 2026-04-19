package com.myguard.vehicle.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


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
    private Object entryTime;
    private Object exitTime;
    private String visitorEntryId;
    private String societyId;
    private Object createdAt;
}
