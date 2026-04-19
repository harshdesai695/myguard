package com.myguard.visitor.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Firestore collection: /pre_approvals/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PreApprovalEntity {
    private String id;
    private String visitorName;
    private String visitorPhone;
    private String purpose;
    private String flatId;
    private String residentUid;
    private String societyId;
    private String inviteCode;
    private String status;
    private Object validFrom;
    private Object validUntil;
    private Object createdAt;
}
