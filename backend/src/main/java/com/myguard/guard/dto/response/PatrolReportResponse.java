package com.myguard.guard.dto.response;

import lombok.Builder;
import lombok.Value;

@Value @Builder
public class PatrolReportResponse {
    long totalCheckpoints;
    long completedScans;
    long missedScans;
    double completionRate;
    String dateRange;
}
