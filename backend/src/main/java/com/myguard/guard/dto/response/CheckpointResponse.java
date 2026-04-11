package com.myguard.guard.dto.response;

import lombok.Builder;
import lombok.Value;
import java.time.Instant;

@Value @Builder
public class CheckpointResponse {
    String id; String name; String description; String societyId;
    double latitude; double longitude; String qrCode; Instant createdAt;
}
