package com.myguard.visitor.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Firestore collection: /visitors/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VisitorEntity {
    private String id;
    private String visitorName;
    private String visitorPhone;
    private String photoUrl;
    private String purpose;
    private String flatId;
    private String residentUid;
    private String societyId;
    private Object entryTime;
    private Object exitTime;
    private String status;
    private String vehicleNumber;
    private String guardUid;
    private String preApprovalId;
    private String inviteCode;
    private boolean isGroupEntry;
    private int groupSize;
    private Object createdAt;
    private Object updatedAt;
}
