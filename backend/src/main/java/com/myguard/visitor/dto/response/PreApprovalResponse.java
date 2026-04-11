package com.myguard.visitor.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class PreApprovalResponse {
    String id;
    String visitorName;
    String visitorPhone;
    String purpose;
    String flatId;
    String residentUid;
    String inviteCode;
    String status;
    Instant validFrom;
    Instant validUntil;
    Instant createdAt;
}
