package com.myguard.dailyhelp.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class DailyHelpResponse {
    String id;
    String name;
    String phone;
    String photoUrl;
    String type;
    String residentUid;
    List<String> flatIds;
    String societyId;
    String schedule;
    Instant createdAt;
    Instant updatedAt;
}
