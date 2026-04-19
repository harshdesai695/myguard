package com.myguard.emergency.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class ChildAlertResponse {
    String id;
    String childName;
    String flatId;
    String residentUid;
    String type;
    String gateId;
    String societyId;
    Instant timestamp;
    Instant createdAt;
}
