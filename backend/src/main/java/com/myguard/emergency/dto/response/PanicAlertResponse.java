package com.myguard.emergency.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class PanicAlertResponse {
    String id;
    String flatId;
    String triggeredBy;
    Instant timestamp;
    String location;
    String status;
    String resolvedBy;
    Instant resolvedAt;
    String societyId;
    Instant createdAt;
}
