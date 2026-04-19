package com.myguard.emergency.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Firestore collection: /child_alerts/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChildAlertEntity {
    private String id;
    private String childName;
    private String flatId;
    private String residentUid;
    private String type; // ENTRY or EXIT
    private String gateId;
    private String societyId;
    private Object timestamp;
    private Object createdAt;
}
