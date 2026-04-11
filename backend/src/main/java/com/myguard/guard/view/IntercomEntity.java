package com.myguard.guard.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/** Firestore collection: /guard_intercoms/{id} */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class IntercomEntity {
    private String id;
    private String guardUid;
    private String flatId;
    private String message;
    private String societyId;
    private Instant createdAt;
}
