package com.myguard.guard.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/** Firestore collection: /guard_patrols/{id} */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PatrolEntity {
    private String id;
    private String guardUid;
    private String checkpointId;
    private String societyId;
    private Object scannedAt;
    private String notes;
    private Object createdAt;
}
