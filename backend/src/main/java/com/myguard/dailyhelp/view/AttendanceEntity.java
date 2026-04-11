package com.myguard.dailyhelp.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /daily_help_attendance/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AttendanceEntity {
    private String id;
    private String dailyHelpId;
    private String guardUid;
    private Instant entryTime;
    private Instant exitTime;
    private String date;
    private String status;
    private Instant createdAt;
}
