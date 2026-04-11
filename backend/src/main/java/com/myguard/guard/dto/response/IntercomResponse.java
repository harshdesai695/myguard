package com.myguard.guard.dto.response;

import lombok.Builder;
import lombok.Value;
import java.time.Instant;

@Value @Builder
public class IntercomResponse {
    String id; String guardUid; String flatId; String message;
    String societyId; Instant createdAt;
}
