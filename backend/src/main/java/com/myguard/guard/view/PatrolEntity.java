package com.myguard.guard.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/** Firestore collection: /guard_patrols/{id} */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PatrolEntity {
    private String id;
    private String guardUid;
    private String checkpointId;
    private String societyId;
    private Instant scannedAt;
    private String notes;
    private Instant createdAt;
}
