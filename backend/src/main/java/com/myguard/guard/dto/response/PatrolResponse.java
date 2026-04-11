package com.myguard.guard.dto.response;

import lombok.Builder;
import lombok.Value;
import java.time.Instant;

@Value @Builder
public class PatrolResponse {
    String id; String guardUid; String checkpointId; String societyId;
    Instant scannedAt; String notes; Instant createdAt;
}
