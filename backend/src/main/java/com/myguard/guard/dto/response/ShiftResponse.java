package com.myguard.guard.dto.response;

import lombok.Builder;
import lombok.Value;
import java.time.Instant;

@Value @Builder
public class ShiftResponse {
    String id; String guardUid; String societyId; String shiftName;
    String startTime; String endTime; String date; String status; Instant createdAt;
}
