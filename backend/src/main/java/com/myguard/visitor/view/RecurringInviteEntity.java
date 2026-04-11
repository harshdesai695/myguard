package com.myguard.visitor.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /recurring_invites/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecurringInviteEntity {
    private String id;
    private String visitorName;
    private String visitorPhone;
    private String purpose;
    private String flatId;
    private String residentUid;
    private String societyId;
    private String status;
    private Instant validFrom;
    private Instant validUntil;
    private Instant createdAt;
}
