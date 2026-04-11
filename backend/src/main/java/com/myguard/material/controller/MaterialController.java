package com.myguard.material.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.material.dto.request.CreateGatepassRequest;
import com.myguard.material.dto.response.GatepassResponse;
import com.myguard.material.service.MaterialService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/material-gatepasses")
@RequiredArgsConstructor
public class MaterialController {

    private final MaterialService materialService;

    @PostMapping
    @PreAuthorize("hasAnyRole('RESIDENT', 'ADMIN')")
    public ResponseEntity<ApiResponse<GatepassResponse>> createGatepass(
            @Valid @RequestBody CreateGatepassRequest request) {
        GatepassResponse response = materialService.createGatepass(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Gatepass created"));
    }

    @GetMapping
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<GatepassResponse>>> listMyGatepasses(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<GatepassResponse> response = materialService.listMyGatepasses(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<GatepassResponse>> getGatepass(@PathVariable String id) {
        GatepassResponse response = materialService.getGatepassById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<GatepassResponse>> approveGatepass(@PathVariable String id) {
        GatepassResponse response = materialService.approveGatepass(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Gatepass approved"));
    }

    @PatchMapping("/{id}/verify")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<GatepassResponse>> verifyGatepass(@PathVariable String id) {
        GatepassResponse response = materialService.verifyGatepass(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Gatepass verified"));
    }

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<GatepassResponse>>> listAllGatepasses(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) String status) {
        PaginatedResponse<GatepassResponse> response = materialService.listAllGatepasses(page, size, societyId, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
