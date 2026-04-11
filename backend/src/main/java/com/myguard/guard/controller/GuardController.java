package com.myguard.guard.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.guard.dto.request.*;
import com.myguard.guard.dto.response.*;
import com.myguard.guard.service.GuardService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;

@Slf4j
@RestController
@RequestMapping("/api/v1/guards")
@RequiredArgsConstructor
public class GuardController {

    private final GuardService guardService;

    @PostMapping("/patrols/checkpoints")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<CheckpointResponse>> createCheckpoint(@Valid @RequestBody CreateCheckpointRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(guardService.createCheckpoint(request), "Checkpoint created"));
    }

    @GetMapping("/patrols/checkpoints")
    @PreAuthorize("hasAnyRole('ADMIN', 'GUARD')")
    public ResponseEntity<ApiResponse<PaginatedResponse<CheckpointResponse>>> listCheckpoints(
            @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(ApiResponse.success(guardService.listCheckpoints(page, size)));
    }

    @PostMapping("/patrols")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<PatrolResponse>> logPatrol(@Valid @RequestBody LogPatrolRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(guardService.logPatrol(request), "Patrol logged"));
    }

    @GetMapping("/patrols")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<PatrolResponse>>> listPatrols(
            @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String guardUid,
            @RequestParam(required = false) Instant from, @RequestParam(required = false) Instant to) {
        return ResponseEntity.ok(ApiResponse.success(guardService.listPatrols(page, size, guardUid, from, to)));
    }

    @GetMapping("/patrols/report")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PatrolReportResponse>> getPatrolReport(
            @RequestParam Instant from, @RequestParam Instant to) {
        return ResponseEntity.ok(ApiResponse.success(guardService.getPatrolReport(from, to)));
    }

    @PostMapping("/shifts")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ShiftResponse>> createShift(@Valid @RequestBody CreateShiftRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(guardService.createShift(request), "Shift created"));
    }

    @GetMapping("/shifts")
    @PreAuthorize("hasAnyRole('ADMIN', 'GUARD')")
    public ResponseEntity<ApiResponse<PaginatedResponse<ShiftResponse>>> listShifts(
            @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(ApiResponse.success(guardService.listShifts(page, size)));
    }

    @PostMapping("/e-intercom/{flatId}")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<IntercomResponse>> sendIntercom(
            @PathVariable String flatId, @Valid @RequestBody SendIntercomRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(guardService.sendIntercom(flatId, request), "Intercom sent"));
    }
}
