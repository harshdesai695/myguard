package com.myguard.dailyhelp.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class AttendanceResponse {
    String id;
    String dailyHelpId;
    String guardUid;
    Instant entryTime;
    Instant exitTime;
    String date;
    String status;
    Instant createdAt;
}
