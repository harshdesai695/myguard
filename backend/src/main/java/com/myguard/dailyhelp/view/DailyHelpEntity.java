package com.myguard.dailyhelp.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /daily_helps/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyHelpEntity {
    private String id;
    private String name;
    private String phone;
    private String photoUrl;
    private String type;
    private String residentUid;
    private List<String> flatIds;
    private String societyId;
    private String schedule;
    private Instant createdAt;
    private Instant updatedAt;
}
