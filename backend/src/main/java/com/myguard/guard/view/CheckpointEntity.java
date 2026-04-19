package com.myguard.guard.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/** Firestore collection: /guard_checkpoints/{id} */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class CheckpointEntity {
    private String id;
    private String name;
    private String description;
    private String societyId;
    private double latitude;
    private double longitude;
    private String qrCode;
    private Object createdAt;
}
