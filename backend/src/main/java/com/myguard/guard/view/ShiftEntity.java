package com.myguard.guard.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/** Firestore collection: /guard_shifts/{id} */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ShiftEntity {
    private String id;
    private String guardUid;
    private String societyId;
    private String shiftName;
    private String startTime;
    private String endTime;
    private String date;
    private String status;
    private Object createdAt;
}
