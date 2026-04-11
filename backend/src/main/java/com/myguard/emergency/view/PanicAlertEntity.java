package com.myguard.emergency.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

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
    private Instant timestamp;
    private String location;
    private String status;
    private String resolvedBy;
    private Instant resolvedAt;
    private String societyId;
    private Instant createdAt;
}
