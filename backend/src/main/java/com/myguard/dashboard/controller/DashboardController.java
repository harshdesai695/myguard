package com.myguard.dashboard.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.dashboard.dto.response.AmenityStatsResponse;
import com.myguard.dashboard.dto.response.DashboardSummaryResponse;
import com.myguard.dashboard.dto.response.GuardPerformanceResponse;
import com.myguard.dashboard.dto.response.HelpdeskStatsResponse;
import com.myguard.dashboard.dto.response.MoveInOutResponse;
import com.myguard.dashboard.dto.response.VisitorStatsResponse;
import com.myguard.dashboard.service.DashboardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

@Slf4j
@RestController
@RequestMapping("/api/v1/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/summary")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<DashboardSummaryResponse>> getSummary(
            @RequestParam(required = false) String societyId) {
        DashboardSummaryResponse response = dashboardService.getSummary(societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/visitor-stats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<VisitorStatsResponse>> getVisitorStats(
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to) {
        VisitorStatsResponse response = dashboardService.getVisitorStats(societyId, from, to);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/helpdesk-stats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<HelpdeskStatsResponse>> getHelpdeskStats(
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to) {
        HelpdeskStatsResponse response = dashboardService.getHelpdeskStats(societyId, from, to);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/amenity-stats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<AmenityStatsResponse>> getAmenityStats(
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to) {
        AmenityStatsResponse response = dashboardService.getAmenityStats(societyId, from, to);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/guard-performance")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<GuardPerformanceResponse>> getGuardPerformance(
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to) {
        GuardPerformanceResponse response = dashboardService.getGuardPerformance(societyId, from, to);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/move-in-out")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<MoveInOutResponse>> getMoveInOutStats(
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to) {
        MoveInOutResponse response = dashboardService.getMoveInOutStats(societyId, from, to);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
