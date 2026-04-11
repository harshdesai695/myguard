package com.myguard.dashboard.service;

import com.myguard.dashboard.dto.response.AmenityStatsResponse;
import com.myguard.dashboard.dto.response.DashboardSummaryResponse;
import com.myguard.dashboard.dto.response.GuardPerformanceResponse;
import com.myguard.dashboard.dto.response.HelpdeskStatsResponse;
import com.myguard.dashboard.dto.response.MoveInOutResponse;
import com.myguard.dashboard.dto.response.VisitorStatsResponse;
import com.myguard.dashboard.repository.DashboardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final DashboardRepository dashboardRepository;

    @Override
    public DashboardSummaryResponse getSummary(String societyId) {
        log.info("[DASHBOARD] Fetching summary for society: {}", societyId);
        return dashboardRepository.getSummary(societyId);
    }

    @Override
    public VisitorStatsResponse getVisitorStats(String societyId, Instant from, Instant to) {
        log.info("[DASHBOARD] Fetching visitor stats for society: {}", societyId);
        return dashboardRepository.getVisitorStats(societyId, from, to);
    }

    @Override
    public HelpdeskStatsResponse getHelpdeskStats(String societyId, Instant from, Instant to) {
        log.info("[DASHBOARD] Fetching helpdesk stats for society: {}", societyId);
        return dashboardRepository.getHelpdeskStats(societyId, from, to);
    }

    @Override
    public AmenityStatsResponse getAmenityStats(String societyId, Instant from, Instant to) {
        log.info("[DASHBOARD] Fetching amenity stats for society: {}", societyId);
        return dashboardRepository.getAmenityStats(societyId, from, to);
    }

    @Override
    public GuardPerformanceResponse getGuardPerformance(String societyId, Instant from, Instant to) {
        log.info("[DASHBOARD] Fetching guard performance for society: {}", societyId);
        return dashboardRepository.getGuardPerformance(societyId, from, to);
    }

    @Override
    public MoveInOutResponse getMoveInOutStats(String societyId, Instant from, Instant to) {
        log.info("[DASHBOARD] Fetching move-in/out stats for society: {}", societyId);
        return dashboardRepository.getMoveInOutStats(societyId, from, to);
    }
}
