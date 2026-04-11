package com.myguard.visitor.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class VisitorResponse {
    String id;
    String visitorName;
    String visitorPhone;
    String photoUrl;
    String purpose;
    String flatId;
    String residentUid;
    String societyId;
    Instant entryTime;
    Instant exitTime;
    String status;
    String vehicleNumber;
    String guardUid;
    String preApprovalId;
    String inviteCode;
    boolean isGroupEntry;
    int groupSize;
    Instant createdAt;
}
