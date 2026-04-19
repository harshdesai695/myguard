package com.myguard.emergency.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Firestore collection: /panic_alerts/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PanicAlertEntity {
    private String id;
    private String flatId;
    private String triggeredBy;
    private Object timestamp;
    private String location;
    private String status;
    private String resolvedBy;
    private Object resolvedAt;
    private String societyId;
    private Object createdAt;
}
