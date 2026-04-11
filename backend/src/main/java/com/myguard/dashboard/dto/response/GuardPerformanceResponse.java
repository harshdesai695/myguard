package com.myguard.dashboard.dto.response;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class GuardPerformanceResponse {
    long totalPatrols;
    long completedPatrols;
    long missedCheckpoints;
    double completionRate;
}
