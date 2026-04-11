package com.myguard.dashboard.dto.response;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class VisitorStatsResponse {
    long dailyCount;
    long weeklyCount;
    long monthlyCount;
    long pendingApprovals;
    long activeVisitors;
}
