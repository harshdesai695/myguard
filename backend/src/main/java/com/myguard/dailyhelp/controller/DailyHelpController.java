package com.myguard.dailyhelp.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.dailyhelp.dto.request.CreateDailyHelpRequest;
import com.myguard.dailyhelp.dto.request.UpdateDailyHelpRequest;
import com.myguard.dailyhelp.dto.response.AttendanceResponse;
import com.myguard.dailyhelp.dto.response.AttendanceSummaryResponse;
import com.myguard.dailyhelp.dto.response.DailyHelpResponse;
import com.myguard.dailyhelp.service.DailyHelpService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/daily-helps")
@RequiredArgsConstructor
public class DailyHelpController {

    private final DailyHelpService dailyHelpService;

    @PostMapping
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<DailyHelpResponse>> create(
            @Valid @RequestBody CreateDailyHelpRequest request) {
        DailyHelpResponse response = dailyHelpService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Daily help registered"));
    }

    @GetMapping
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<DailyHelpResponse>>> listMyDailyHelps(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(ApiResponse.success(dailyHelpService.listMyDailyHelps(page, size)));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<DailyHelpResponse>> getById(@PathVariable String id) {
        return ResponseEntity.ok(ApiResponse.success(dailyHelpService.getById(id)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<DailyHelpResponse>> update(
            @PathVariable String id,
            @Valid @RequestBody UpdateDailyHelpRequest request) {
        return ResponseEntity.ok(ApiResponse.success(dailyHelpService.update(id, request), "Daily help updated"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable String id) {
        dailyHelpService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Daily help removed"));
    }

    @PostMapping("/{id}/attendance")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<AttendanceResponse>> markAttendance(@PathVariable String id) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(dailyHelpService.markAttendance(id), "Attendance marked"));
    }

    @GetMapping("/{id}/attendance")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<AttendanceResponse>>> getAttendanceHistory(
            @PathVariable String id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(ApiResponse.success(dailyHelpService.getAttendanceHistory(id, page, size)));
    }

    @GetMapping("/{id}/attendance/summary")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<AttendanceSummaryResponse>> getAttendanceSummary(
            @PathVariable String id,
            @RequestParam String month) {
        return ResponseEntity.ok(ApiResponse.success(dailyHelpService.getAttendanceSummary(id, month)));
    }
}
