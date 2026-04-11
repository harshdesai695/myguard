package com.myguard.dashboard.repository;

import com.myguard.dashboard.dto.response.AmenityStatsResponse;
import com.myguard.dashboard.dto.response.DashboardSummaryResponse;
import com.myguard.dashboard.dto.response.GuardPerformanceResponse;
import com.myguard.dashboard.dto.response.HelpdeskStatsResponse;
import com.myguard.dashboard.dto.response.MoveInOutResponse;
import com.myguard.dashboard.dto.response.VisitorStatsResponse;

import java.time.Instant;

public interface DashboardRepository {

    DashboardSummaryResponse getSummary(String societyId);
    VisitorStatsResponse getVisitorStats(String societyId, Instant from, Instant to);
    HelpdeskStatsResponse getHelpdeskStats(String societyId, Instant from, Instant to);
    AmenityStatsResponse getAmenityStats(String societyId, Instant from, Instant to);
    GuardPerformanceResponse getGuardPerformance(String societyId, Instant from, Instant to);
    MoveInOutResponse getMoveInOutStats(String societyId, Instant from, Instant to);
}
